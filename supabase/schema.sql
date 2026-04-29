-- ============================================================================
-- PRINTSARI SIA — CANONICAL SCHEMA
-- ============================================================================
-- This file represents the FINAL state of the database after all migrations.
-- Use it as a quick reference or for fresh installs:
--   psql $DATABASE_URL -f schema.sql
--
-- For normal dev, still use: npx supabase db reset
-- (which runs migrations/ in order, then seed.sql)
-- ============================================================================

-- ============================================================================
-- CLEAN SLATE
-- ============================================================================

DROP TABLE IF EXISTS expenses_by_category CASCADE;
DROP TABLE IF EXISTS department_revenues CASCADE;
DROP TABLE IF EXISTS trend_data_points CASCADE;
DROP TABLE IF EXISTS monthly_metrics CASCADE;
DROP TABLE IF EXISTS weekly_metrics CASCADE;
DROP TABLE IF EXISTS daily_metrics CASCADE;
DROP TABLE IF EXISTS financial_reports CASCADE;
DROP TABLE IF EXISTS activity_logs CASCADE;
DROP TABLE IF EXISTS stock_out CASCADE;
DROP TABLE IF EXISTS stock_in CASCADE;
DROP TABLE IF EXISTS inventory_items CASCADE;
DROP TABLE IF EXISTS transaction_items CASCADE;
DROP TABLE IF EXISTS print_orders CASCADE;
DROP TABLE IF EXISTS expenses CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS service_type_costs CASCADE;
DROP TABLE IF EXISTS service_types CASCADE;
DROP TABLE IF EXISTS machines CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS service_supplies CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS login_history CASCADE;
DROP TABLE IF EXISTS vendors CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

DROP TABLE IF EXISTS report_periods CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS payment_methods CASCADE;
DROP TABLE IF EXISTS transaction_statuses CASCADE;
DROP TABLE IF EXISTS product_categories CASCADE;
DROP TABLE IF EXISTS expense_sources CASCADE;
DROP TABLE IF EXISTS expense_categories CASCADE;
DROP TABLE IF EXISTS activity_actions CASCADE;

DROP FUNCTION IF EXISTS get_email_by_username(text) CASCADE;
DROP FUNCTION IF EXISTS public.is_owner() CASCADE;
DROP FUNCTION IF EXISTS public.get_user_role() CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

DROP POLICY IF EXISTS "Users can upload avatars" ON storage.objects;
DROP POLICY IF EXISTS "Users can update avatars" ON storage.objects;
DROP POLICY IF EXISTS "Public avatar read access" ON storage.objects;

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- is_owner() — both 'owner' (super-admin) and 'manager' can perform owner actions
CREATE OR REPLACE FUNCTION public.is_owner()
RETURNS boolean AS $$
  SELECT EXISTS (
    SELECT 1
    FROM profiles p
    JOIN user_roles ur ON p.role_id = ur.id
    WHERE p.user_id = auth.uid()
      AND ur.role_name IN ('owner', 'manager')
      AND p.is_active = true
  )
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS text AS $$
  SELECT ur.role_name
  FROM profiles p
  JOIN user_roles ur ON p.role_id = ur.id
  WHERE p.user_id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION get_email_by_username(lookup_username text)
RETURNS text
LANGUAGE sql SECURITY DEFINER AS $$
  SELECT au.email
  FROM auth.users au
  JOIN public.profiles p ON p.user_id = au.id
  WHERE p.username = lookup_username
  LIMIT 1;
$$;

-- ============================================================================
-- LOOKUP / ENUM TABLES
-- ============================================================================

CREATE TABLE activity_actions (
  id          int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  action_name text NOT NULL UNIQUE,
  category    text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE expense_categories (
  id            int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  category_name text NOT NULL UNIQUE,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE expense_sources (
  id          int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  source_name text NOT NULL UNIQUE,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- product_categories is kept for transaction_items.category_id (1=store, 2=print)
CREATE TABLE product_categories (
  id            int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  category_name text NOT NULL UNIQUE,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE transaction_statuses (
  id          int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  status_name text NOT NULL UNIQUE,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE payment_methods (
  id          int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  method_name text NOT NULL UNIQUE,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- Roles: 'owner' (super-admin), 'manager', 'cashier'
CREATE TABLE user_roles (
  id        int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  role_name text NOT NULL UNIQUE,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE report_periods (
  id          int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  period_name text NOT NULL UNIQUE,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- Seed lookup data
INSERT INTO activity_actions (action_name, category) VALUES
  ('transaction_created',     'transaction'),
  ('transaction_cancelled',   'transaction'),
  ('transaction_refunded',    'transaction'),
  ('product_created',         'product'),
  ('product_updated',         'product'),
  ('product_deleted',         'product'),
  ('inventory_added',         'inventory'),
  ('inventory_updated',       'inventory'),
  ('inventory_depleted',      'inventory'),
  ('inventory_expired',       'inventory'),
  ('user_created',            'user'),
  ('user_updated',            'user'),
  ('user_deleted',            'user'),
  ('user_login',              'user'),
  ('user_logout',             'user'),
  ('expense_created',         'expense'),
  ('expense_updated',         'expense'),
  ('expense_deleted',         'expense'),
  ('customer_created',        'customer'),
  ('customer_updated',        'customer'),
  ('customer_deleted',        'customer'),
  ('Transaction Completed',   'transaction'),
  ('Transaction Voided',      'transaction'),
  ('Inventory Restocked',     'inventory'),
  ('Inventory Adjusted',      'inventory'),
  ('User Login',              'user'),
  ('User Created',            'user'),
  ('Expense Recorded',        'expense'),
  ('Customer Registered',     'customer'),
  ('Print Order Created',     'print_service'),
  ('Product Added',           'product'),
  ('Machine Added',           'machine'),
  ('Machine Updated',         'machine'),
  ('Machine Deleted',         'machine'),
  ('Service Supply Added',    'service_supply'),
  ('Service Supply Updated',  'service_supply'),
  ('Service Supply Deleted',  'service_supply'),
  ('Stock In',                'inventory'),
  ('Stock Out',               'inventory')
ON CONFLICT DO NOTHING;

INSERT INTO expense_categories (category_name) VALUES
  ('printing_ink'),
  ('printing_paper'),
  ('printing_electricity'),
  ('printing_maintenance'),
  ('store_inventory'),
  ('utilities'),
  ('rent'),
  ('salaries'),
  ('supplies'),
  ('other'),
  ('purchases');

INSERT INTO expense_sources (source_name) VALUES ('manual'), ('auto_print');

INSERT INTO product_categories (category_name) VALUES ('store'), ('printing');

INSERT INTO transaction_statuses (status_name) VALUES
  ('completed'), ('pending'), ('cancelled'), ('refunded');

INSERT INTO payment_methods (method_name) VALUES
  ('cash'), ('gcash'), ('card'), ('credit');

INSERT INTO user_roles (role_name) VALUES ('owner'), ('manager'), ('cashier');

INSERT INTO report_periods (period_name) VALUES ('daily'), ('weekly'), ('monthly');

-- ============================================================================
-- CORE TABLES
-- ============================================================================

CREATE TABLE profiles (
  id                  int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id             uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  username            text NOT NULL UNIQUE,
  role_id             int8 NOT NULL REFERENCES user_roles(id),
  name                text NOT NULL,
  phone               text,
  profile_picture     text,
  address_street      text,
  address_barangay    text,
  address_city        text,
  address_province    text,
  address_region      text,
  address_postal_code text,
  address_country     text,
  is_active           boolean NOT NULL DEFAULT true,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_profiles_user_id  ON profiles(user_id);
CREATE INDEX idx_profiles_username ON profiles(username);
CREATE INDEX idx_profiles_role_id  ON profiles(role_id);

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE customers (
  id              int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name            text,
  email           text NOT NULL,
  phone           text,
  address         text,
  notes           text,
  registered_date timestamptz NOT NULL DEFAULT now(),
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_customers_email           ON customers(email);
CREATE INDEX idx_customers_registered_date ON customers(registered_date);

CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON customers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE vendors (
  id             int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name           text NOT NULL,
  contact_number text,
  email          text,
  address        text,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_vendors_name ON vendors(name);

CREATE TRIGGER update_vendors_updated_at BEFORE UPDATE ON vendors
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Seed default vendor
INSERT INTO vendors (name, address)
VALUES ('PrintSari Corner', 'Magpet, North Cotabato')
ON CONFLICT DO NOTHING;

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE products (
  id               int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name             text NOT NULL,
  product_category text NOT NULL DEFAULT '',
  product_type     text NOT NULL DEFAULT '',
  purchase_price   numeric(12, 2) NOT NULL,
  selling_price    numeric(12, 2),
  expiry_date      date,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_products_name ON products(name);

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE service_supplies (
  id             int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name           text NOT NULL,
  supply_type    text NOT NULL,
  paper_size     text,
  purchase_price numeric(12, 2) NOT NULL DEFAULT 0,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_service_supplies_supply_type ON service_supplies(supply_type);

CREATE TRIGGER update_service_supplies_updated_at BEFORE UPDATE ON service_supplies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE services (
  id         int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name       text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

-- One machine belongs to one service (its primary service group)
CREATE TABLE machines (
  id         int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name       text NOT NULL,
  is_active  boolean NOT NULL DEFAULT true,
  service_id int8 REFERENCES services(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_machines_is_active  ON machines(is_active);
CREATE INDEX idx_machines_service_id ON machines(service_id);

CREATE TRIGGER update_machines_updated_at BEFORE UPDATE ON machines
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

-- One service_type = one specific printable variant (e.g. "Print B&W A4")
CREATE TABLE service_types (
  id                int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service_id        int8 NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  service_supply_id int8 REFERENCES service_supplies(id) ON DELETE SET NULL,
  machine_id        int8 REFERENCES machines(id) ON DELETE SET NULL,
  name              text NOT NULL,
  paper_size        text,
  color_mode        text,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_service_types_service_id ON service_types(service_id);
CREATE INDEX idx_service_types_machine_id ON service_types(machine_id);

CREATE TRIGGER update_service_types_updated_at BEFORE UPDATE ON service_types
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

-- Cost breakdown per service type; service_total_cost is auto-computed
CREATE TABLE service_type_costs (
  id                   int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service_type_id      int8 NOT NULL REFERENCES service_types(id) ON DELETE CASCADE,
  service_supply_cost  numeric(12, 2) NOT NULL DEFAULT 0,
  ink_cost             numeric(12, 2) NOT NULL DEFAULT 0,
  electricity_cost     numeric(12, 2) NOT NULL DEFAULT 0,
  labor_cost           numeric(12, 2) NOT NULL DEFAULT 0,
  service_total_cost   numeric(12, 2) GENERATED ALWAYS AS
                         (service_supply_cost + ink_cost + electricity_cost + labor_cost) STORED,
  service_selling_price numeric(12, 2) NOT NULL DEFAULT 0,
  last_updated         timestamptz NOT NULL DEFAULT now(),
  created_at           timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_service_type_costs_service_type_id ON service_type_costs(service_type_id);

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE transactions (
  id                 int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  transaction_number text NOT NULL UNIQUE,
  subtotal           numeric(12, 2) NOT NULL,
  tax                numeric(12, 2),
  discount           numeric(12, 2),
  total              numeric(12, 2) NOT NULL,
  date               timestamptz NOT NULL DEFAULT now(),
  status_id          int8 NOT NULL REFERENCES transaction_statuses(id),
  payment_method_id  int8 NOT NULL REFERENCES payment_methods(id),
  cashier_id         int8 NOT NULL REFERENCES profiles(id),
  customer_id        int8 REFERENCES customers(id),
  notes              text,
  store_revenue      numeric(12, 2) NOT NULL DEFAULT 0,
  printing_revenue   numeric(12, 2) NOT NULL DEFAULT 0,
  total_cost         numeric(12, 2),
  gross_profit       numeric(12, 2),
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_transactions_transaction_number ON transactions(transaction_number);
CREATE INDEX idx_transactions_date              ON transactions(date);
CREATE INDEX idx_transactions_status_id         ON transactions(status_id);
CREATE INDEX idx_transactions_cashier_id        ON transactions(cashier_id);
CREATE INDEX idx_transactions_customer_id       ON transactions(customer_id);

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE print_orders (
  id               int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service_type_id  int8 REFERENCES service_types(id) ON DELETE SET NULL,
  quantity         int4 NOT NULL,
  total_price      numeric(12, 2) NOT NULL,
  ink_used         numeric(12, 2) NOT NULL,
  paper_used       numeric(12, 2) NOT NULL,
  electricity_used numeric(12, 4) NOT NULL,
  total_cost       numeric(12, 2) NOT NULL,
  profit_margin    numeric(12, 2) NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_print_orders_service_type_id ON print_orders(service_type_id);

CREATE TRIGGER update_print_orders_updated_at BEFORE UPDATE ON print_orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE expenses (
  id                    int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  description           text NOT NULL,
  amount                numeric(12, 2) NOT NULL,
  category_id           int8 NOT NULL REFERENCES expense_categories(id),
  date                  timestamptz NOT NULL DEFAULT now(),
  receipt_number        text,
  vendor_id             int8 REFERENCES vendors(id) ON DELETE SET NULL,
  payment_method_id     int8 REFERENCES payment_methods(id),
  notes                 text,
  linked_transaction_id int8 REFERENCES transactions(id),
  source_id             int8 NOT NULL REFERENCES expense_sources(id),
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_expenses_category_id           ON expenses(category_id);
CREATE INDEX idx_expenses_date                  ON expenses(date);
CREATE INDEX idx_expenses_source_id             ON expenses(source_id);
CREATE INDEX idx_expenses_vendor_id             ON expenses(vendor_id);
CREATE INDEX idx_expenses_linked_transaction_id ON expenses(linked_transaction_id);

CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON expenses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE stock_in (
  id                int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  product_id        int8 REFERENCES products(id) ON DELETE SET NULL,
  service_supply_id int8 REFERENCES service_supplies(id) ON DELETE SET NULL,
  user_id           int8 NOT NULL REFERENCES profiles(id),
  expense_id        int8 REFERENCES expenses(id) ON DELETE SET NULL,
  purchase_price    numeric(12, 2) NOT NULL DEFAULT 0,
  quantity_added    numeric(12, 2) NOT NULL DEFAULT 0,
  expiry_date       date,
  stock_in_date     timestamptz NOT NULL DEFAULT now(),
  created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_stock_in_product_id        ON stock_in(product_id);
CREATE INDEX idx_stock_in_service_supply_id ON stock_in(service_supply_id);
CREATE INDEX idx_stock_in_user_id           ON stock_in(user_id);
CREATE INDEX idx_stock_in_stock_in_date     ON stock_in(stock_in_date);

-- ────────────────────────────────────────────────────────────────────────────

-- One row = one product batch OR one supply batch (enforced by CHECK)
CREATE TABLE inventory_items (
  id                int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  product_id        int8 REFERENCES products(id) ON DELETE CASCADE,
  service_supply_id int8 REFERENCES service_supplies(id) ON DELETE CASCADE,
  stock             numeric(12, 2) NOT NULL DEFAULT 0,
  retail_price      numeric(12, 2) NOT NULL,
  reorder_level     numeric(12, 2),
  location          text,
  last_restocked    timestamptz,
  stock_in_id       int8 REFERENCES stock_in(id) ON DELETE SET NULL,
  expiry_date       date,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT chk_inventory_item_type CHECK (
    (product_id IS NOT NULL AND service_supply_id IS NULL) OR
    (product_id IS NULL     AND service_supply_id IS NOT NULL)
  )
);

CREATE INDEX idx_inventory_items_product_id        ON inventory_items(product_id);
CREATE INDEX idx_inventory_items_service_supply_id ON inventory_items(service_supply_id);
CREATE INDEX idx_inventory_items_stock_in_id       ON inventory_items(stock_in_id);
CREATE INDEX idx_inventory_items_expiry_date       ON inventory_items(expiry_date);
CREATE INDEX idx_inventory_items_stock             ON inventory_items(stock);

-- Unique: one inventory row per supply (partial index)
CREATE UNIQUE INDEX idx_inventory_items_unique_supply
  ON inventory_items(service_supply_id)
  WHERE service_supply_id IS NOT NULL;

CREATE TRIGGER update_inventory_items_updated_at BEFORE UPDATE ON inventory_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE transaction_items (
  id             int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  transaction_id int8 NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
  inventory_id   int8 REFERENCES inventory_items(id) ON DELETE SET NULL,
  product_id     int8 REFERENCES products(id) ON DELETE SET NULL,
  product_name   text NOT NULL,
  quantity       numeric(12, 2) NOT NULL,
  unit_price     numeric(12, 2) NOT NULL,
  subtotal       numeric(12, 2) NOT NULL,
  category_id    int8 NOT NULL REFERENCES product_categories(id),
  discount       numeric(12, 2),
  print_order_id int8 REFERENCES print_orders(id),
  item_cost      numeric(12, 2),
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_transaction_items_transaction_id ON transaction_items(transaction_id);
CREATE INDEX idx_transaction_items_inventory_id   ON transaction_items(inventory_id);
CREATE INDEX idx_transaction_items_product_id     ON transaction_items(product_id);
CREATE INDEX idx_transaction_items_print_order_id ON transaction_items(print_order_id);

CREATE TRIGGER update_transaction_items_updated_at BEFORE UPDATE ON transaction_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE stock_out (
  id                  int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  transaction_id      int8 REFERENCES transactions(id) ON DELETE SET NULL,
  transaction_item_id int8 REFERENCES transaction_items(id) ON DELETE SET NULL,
  product_id          int8 REFERENCES products(id) ON DELETE SET NULL,
  service_supply_id   int8 REFERENCES service_supplies(id) ON DELETE SET NULL,
  inventory_item_id   int8 REFERENCES inventory_items(id) ON DELETE SET NULL,
  user_id             int8 NOT NULL REFERENCES profiles(id),
  quantity_removed    numeric(12, 2) NOT NULL DEFAULT 0,
  stock_out_type      text NOT NULL,
  stock_out_date      timestamptz NOT NULL DEFAULT now(),
  created_at          timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_stock_out_transaction_id    ON stock_out(transaction_id);
CREATE INDEX idx_stock_out_product_id        ON stock_out(product_id);
CREATE INDEX idx_stock_out_service_supply_id ON stock_out(service_supply_id);
CREATE INDEX idx_stock_out_inventory_item_id ON stock_out(inventory_item_id);
CREATE INDEX idx_stock_out_stock_out_date    ON stock_out(stock_out_date);

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE login_history (
  id          int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  profile_id  int8 NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  username    text NOT NULL,
  login_time  timestamptz NOT NULL DEFAULT now(),
  logout_time timestamptz,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_login_history_profile_id ON login_history(profile_id);
CREATE INDEX idx_login_history_login_time ON login_history(login_time);

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE activity_logs (
  id               int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  action_id        int8 NOT NULL REFERENCES activity_actions(id),
  description      text NOT NULL,
  timestamp        timestamptz NOT NULL DEFAULT now(),
  performed_by     text NOT NULL,
  performed_by_id  int8 NOT NULL REFERENCES profiles(id),
  metadata         jsonb,
  created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_activity_logs_action_id        ON activity_logs(action_id);
CREATE INDEX idx_activity_logs_performed_by_id  ON activity_logs(performed_by_id);
CREATE INDEX idx_activity_logs_timestamp        ON activity_logs(timestamp);

-- ────────────────────────────────────────────────────────────────────────────

CREATE TABLE financial_reports (
  id         int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  period_id  int8 NOT NULL REFERENCES report_periods(id),
  start_date timestamptz NOT NULL,
  end_date   timestamptz NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_financial_reports_period_id  ON financial_reports(period_id);
CREATE INDEX idx_financial_reports_start_date ON financial_reports(start_date);
CREATE INDEX idx_financial_reports_end_date   ON financial_reports(end_date);

CREATE TRIGGER update_financial_reports_updated_at BEFORE UPDATE ON financial_reports
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE daily_metrics (
  id                   int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  financial_report_id  int8 NOT NULL REFERENCES financial_reports(id) ON DELETE CASCADE,
  date                 date NOT NULL,
  revenue              numeric(12, 2) NOT NULL,
  store_revenue        numeric(12, 2) NOT NULL,
  printing_revenue     numeric(12, 2) NOT NULL,
  expenses             numeric(12, 2) NOT NULL,
  profit               numeric(12, 2) NOT NULL,
  transaction_count    int4 NOT NULL,
  profit_margin        numeric(5, 2) NOT NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE weekly_metrics (
  id                   int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  financial_report_id  int8 NOT NULL REFERENCES financial_reports(id) ON DELETE CASCADE,
  week_start_date      date NOT NULL,
  week_end_date        date NOT NULL,
  revenue              numeric(12, 2) NOT NULL,
  store_revenue        numeric(12, 2) NOT NULL,
  printing_revenue     numeric(12, 2) NOT NULL,
  expenses             numeric(12, 2) NOT NULL,
  profit               numeric(12, 2) NOT NULL,
  daily_average        numeric(12, 2) NOT NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE monthly_metrics (
  id                   int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  financial_report_id  int8 NOT NULL REFERENCES financial_reports(id) ON DELETE CASCADE,
  month                date NOT NULL,
  revenue              numeric(12, 2) NOT NULL,
  store_revenue        numeric(12, 2) NOT NULL,
  printing_revenue     numeric(12, 2) NOT NULL,
  expenses             numeric(12, 2) NOT NULL,
  profit               numeric(12, 2) NOT NULL,
  daily_average        numeric(12, 2) NOT NULL,
  transaction_count    int4 NOT NULL,
  profit_margin        numeric(5, 2) NOT NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE trend_data_points (
  id                   int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  financial_report_id  int8 NOT NULL REFERENCES financial_reports(id) ON DELETE CASCADE,
  date                 date NOT NULL,
  revenue              numeric(12, 2) NOT NULL,
  store_revenue        numeric(12, 2) NOT NULL,
  printing_revenue     numeric(12, 2) NOT NULL,
  expenses             numeric(12, 2) NOT NULL,
  profit               numeric(12, 2) NOT NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE department_revenues (
  id                   int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  financial_report_id  int8 NOT NULL REFERENCES financial_reports(id) ON DELETE CASCADE,
  name                 text NOT NULL CHECK (name IN ('Store', 'Printing')),
  value                numeric(12, 2) NOT NULL,
  percentage           numeric(5, 2) NOT NULL,
  color                text NOT NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE expenses_by_category (
  id                   int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  financial_report_id  int8 NOT NULL REFERENCES financial_reports(id) ON DELETE CASCADE,
  category_id          int8 NOT NULL REFERENCES expense_categories(id),
  amount               numeric(12, 2) NOT NULL,
  percentage           numeric(5, 2) NOT NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_daily_metrics_financial_report_id   ON daily_metrics(financial_report_id);
CREATE INDEX idx_daily_metrics_date                  ON daily_metrics(date);
CREATE INDEX idx_weekly_metrics_financial_report_id  ON weekly_metrics(financial_report_id);
CREATE INDEX idx_weekly_metrics_week_start_date      ON weekly_metrics(week_start_date);
CREATE INDEX idx_monthly_metrics_financial_report_id ON monthly_metrics(financial_report_id);
CREATE INDEX idx_monthly_metrics_month               ON monthly_metrics(month);
CREATE INDEX idx_trend_data_points_financial_report_id ON trend_data_points(financial_report_id);
CREATE INDEX idx_trend_data_points_date              ON trend_data_points(date);
CREATE INDEX idx_department_revenues_financial_report_id ON department_revenues(financial_report_id);
CREATE INDEX idx_expenses_by_category_financial_report_id ON expenses_by_category(financial_report_id);
CREATE INDEX idx_expenses_by_category_category_id   ON expenses_by_category(category_id);

CREATE TRIGGER update_daily_metrics_updated_at     BEFORE UPDATE ON daily_metrics     FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_weekly_metrics_updated_at    BEFORE UPDATE ON weekly_metrics    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_monthly_metrics_updated_at   BEFORE UPDATE ON monthly_metrics   FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_trend_data_points_updated_at BEFORE UPDATE ON trend_data_points FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_department_revenues_updated_at BEFORE UPDATE ON department_revenues FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_expenses_by_category_updated_at BEFORE UPDATE ON expenses_by_category FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- STORAGE
-- ============================================================================

INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Users can upload avatars"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'avatars');

CREATE POLICY "Users can update avatars"
  ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id = 'avatars');

CREATE POLICY "Public avatar read access"
  ON storage.objects FOR SELECT TO public
  USING (bucket_id = 'avatars');

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE profiles          ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers         ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendors           ENABLE ROW LEVEL SECURITY;
ALTER TABLE products          ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_supplies  ENABLE ROW LEVEL SECURITY;
ALTER TABLE services          ENABLE ROW LEVEL SECURITY;
ALTER TABLE machines          ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_types     ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_type_costs ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_items   ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_in          ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_out         ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions      ENABLE ROW LEVEL SECURITY;
ALTER TABLE print_orders      ENABLE ROW LEVEL SECURITY;
ALTER TABLE transaction_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses          ENABLE ROW LEVEL SECURITY;
ALTER TABLE login_history     ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs     ENABLE ROW LEVEL SECURITY;
ALTER TABLE financial_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_metrics         ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_metrics        ENABLE ROW LEVEL SECURITY;
ALTER TABLE monthly_metrics       ENABLE ROW LEVEL SECURITY;
ALTER TABLE trend_data_points     ENABLE ROW LEVEL SECURITY;
ALTER TABLE department_revenues   ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses_by_category  ENABLE ROW LEVEL SECURITY;

ALTER TABLE activity_actions   ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_sources    ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE transaction_statuses ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods    ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles         ENABLE ROW LEVEL SECURITY;
ALTER TABLE report_periods     ENABLE ROW LEVEL SECURITY;

-- Lookup tables — read-only for all authenticated users
CREATE POLICY "lookup_select" ON activity_actions    FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON expense_categories  FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON expense_sources     FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON product_categories  FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON transaction_statuses FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON payment_methods     FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON user_roles          FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON report_periods      FOR SELECT TO authenticated USING (true);

-- profiles
-- KEY: After signUp(), the new user is auto-logged in; allow them to insert their own row
CREATE POLICY "profiles_select" ON profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "profiles_insert" ON profiles FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "profiles_update" ON profiles FOR UPDATE TO authenticated USING (user_id = auth.uid() OR public.is_owner());
CREATE POLICY "profiles_delete" ON profiles FOR DELETE TO authenticated USING (public.is_owner());

-- customers
CREATE POLICY "customers_select" ON customers FOR SELECT TO authenticated USING (true);
CREATE POLICY "customers_insert" ON customers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "customers_update" ON customers FOR UPDATE TO authenticated USING (true);
CREATE POLICY "customers_delete" ON customers FOR DELETE TO authenticated USING (public.is_owner());

-- vendors
CREATE POLICY "vendors_select" ON vendors FOR SELECT TO authenticated USING (true);
CREATE POLICY "vendors_insert" ON vendors FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "vendors_update" ON vendors FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "vendors_delete" ON vendors FOR DELETE TO authenticated USING (public.is_owner());

-- products
CREATE POLICY "products_select" ON products FOR SELECT TO authenticated USING (true);
CREATE POLICY "products_insert" ON products FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "products_update" ON products FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "products_delete" ON products FOR DELETE TO authenticated USING (public.is_owner());

-- service_supplies
CREATE POLICY "service_supplies_select" ON service_supplies FOR SELECT TO authenticated USING (true);
CREATE POLICY "service_supplies_insert" ON service_supplies FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "service_supplies_update" ON service_supplies FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "service_supplies_delete" ON service_supplies FOR DELETE TO authenticated USING (public.is_owner());

-- services
CREATE POLICY "services_select" ON services FOR SELECT TO authenticated USING (true);
CREATE POLICY "services_insert" ON services FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "services_update" ON services FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "services_delete" ON services FOR DELETE TO authenticated USING (public.is_owner());

-- machines
CREATE POLICY "machines_select" ON machines FOR SELECT TO authenticated USING (true);
CREATE POLICY "machines_insert" ON machines FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "machines_update" ON machines FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "machines_delete" ON machines FOR DELETE TO authenticated USING (public.is_owner());

-- service_types
CREATE POLICY "service_types_select" ON service_types FOR SELECT TO authenticated USING (true);
CREATE POLICY "service_types_insert" ON service_types FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "service_types_update" ON service_types FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "service_types_delete" ON service_types FOR DELETE TO authenticated USING (public.is_owner());

-- service_type_costs
CREATE POLICY "service_type_costs_select" ON service_type_costs FOR SELECT TO authenticated USING (true);
CREATE POLICY "service_type_costs_insert" ON service_type_costs FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "service_type_costs_update" ON service_type_costs FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "service_type_costs_delete" ON service_type_costs FOR DELETE TO authenticated USING (public.is_owner());

-- inventory_items (cashiers update stock during sales)
CREATE POLICY "inventory_items_select" ON inventory_items FOR SELECT TO authenticated USING (true);
CREATE POLICY "inventory_items_insert" ON inventory_items FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "inventory_items_update" ON inventory_items FOR UPDATE TO authenticated USING (true);
CREATE POLICY "inventory_items_delete" ON inventory_items FOR DELETE TO authenticated USING (public.is_owner());

-- stock_in (all authenticated can create — both owner and cashier contexts)
CREATE POLICY "stock_in_select" ON stock_in FOR SELECT TO authenticated USING (true);
CREATE POLICY "stock_in_insert" ON stock_in FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "stock_in_update" ON stock_in FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "stock_in_delete" ON stock_in FOR DELETE TO authenticated USING (public.is_owner());

-- stock_out (cashiers create when completing a sale)
CREATE POLICY "stock_out_select" ON stock_out FOR SELECT TO authenticated USING (true);
CREATE POLICY "stock_out_insert" ON stock_out FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "stock_out_update" ON stock_out FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "stock_out_delete" ON stock_out FOR DELETE TO authenticated USING (public.is_owner());

-- transactions
CREATE POLICY "transactions_select" ON transactions FOR SELECT TO authenticated USING (true);
CREATE POLICY "transactions_insert" ON transactions FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "transactions_update" ON transactions FOR UPDATE TO authenticated
  USING (public.is_owner() OR cashier_id = (SELECT id FROM profiles WHERE user_id = auth.uid()));
CREATE POLICY "transactions_delete" ON transactions FOR DELETE TO authenticated USING (public.is_owner());

-- print_orders
CREATE POLICY "print_orders_select" ON print_orders FOR SELECT TO authenticated USING (true);
CREATE POLICY "print_orders_insert" ON print_orders FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "print_orders_update" ON print_orders FOR UPDATE TO authenticated USING (true);
CREATE POLICY "print_orders_delete" ON print_orders FOR DELETE TO authenticated USING (public.is_owner());

-- transaction_items
CREATE POLICY "transaction_items_select" ON transaction_items FOR SELECT TO authenticated USING (true);
CREATE POLICY "transaction_items_insert" ON transaction_items FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "transaction_items_update" ON transaction_items FOR UPDATE TO authenticated USING (true);
CREATE POLICY "transaction_items_delete" ON transaction_items FOR DELETE TO authenticated USING (public.is_owner());

-- expenses
CREATE POLICY "expenses_select" ON expenses FOR SELECT TO authenticated USING (true);
CREATE POLICY "expenses_insert" ON expenses FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "expenses_update" ON expenses FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "expenses_delete" ON expenses FOR DELETE TO authenticated USING (public.is_owner());

-- login_history (immutable — no delete, users see their own; owners see all)
CREATE POLICY "login_history_select" ON login_history FOR SELECT TO authenticated
  USING (profile_id = (SELECT id FROM profiles WHERE user_id = auth.uid()) OR public.is_owner());
CREATE POLICY "login_history_insert" ON login_history FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "login_history_update" ON login_history FOR UPDATE TO authenticated USING (true);

-- activity_logs (append-only audit trail)
CREATE POLICY "activity_logs_select" ON activity_logs FOR SELECT TO authenticated USING (true);
CREATE POLICY "activity_logs_insert" ON activity_logs FOR INSERT TO authenticated WITH CHECK (true);

-- financial_reports + metrics
CREATE POLICY "financial_reports_select" ON financial_reports FOR SELECT TO authenticated USING (true);
CREATE POLICY "financial_reports_insert" ON financial_reports FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "financial_reports_update" ON financial_reports FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "financial_reports_delete" ON financial_reports FOR DELETE TO authenticated USING (public.is_owner());

CREATE POLICY "daily_metrics_select"        ON daily_metrics        FOR SELECT TO authenticated USING (true);
CREATE POLICY "weekly_metrics_select"       ON weekly_metrics       FOR SELECT TO authenticated USING (true);
CREATE POLICY "monthly_metrics_select"      ON monthly_metrics      FOR SELECT TO authenticated USING (true);
CREATE POLICY "trend_data_points_select"    ON trend_data_points    FOR SELECT TO authenticated USING (true);
CREATE POLICY "department_revenues_select"  ON department_revenues  FOR SELECT TO authenticated USING (true);
CREATE POLICY "expenses_by_category_select" ON expenses_by_category FOR SELECT TO authenticated USING (true);

CREATE POLICY "daily_metrics_insert"        ON daily_metrics        FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "weekly_metrics_insert"       ON weekly_metrics       FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "monthly_metrics_insert"      ON monthly_metrics      FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "trend_data_points_insert"    ON trend_data_points    FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "department_revenues_insert"  ON department_revenues  FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "expenses_by_category_insert" ON expenses_by_category FOR INSERT TO authenticated WITH CHECK (public.is_owner());

CREATE POLICY "daily_metrics_update"        ON daily_metrics        FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "weekly_metrics_update"       ON weekly_metrics       FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "monthly_metrics_update"      ON monthly_metrics      FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "trend_data_points_update"    ON trend_data_points    FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "department_revenues_update"  ON department_revenues  FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "expenses_by_category_update" ON expenses_by_category FOR UPDATE TO authenticated USING (public.is_owner());

CREATE POLICY "daily_metrics_delete"        ON daily_metrics        FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "weekly_metrics_delete"       ON weekly_metrics       FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "monthly_metrics_delete"      ON monthly_metrics      FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "trend_data_points_delete"    ON trend_data_points    FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "department_revenues_delete"  ON department_revenues  FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "expenses_by_category_delete" ON expenses_by_category FOR DELETE TO authenticated USING (public.is_owner());
