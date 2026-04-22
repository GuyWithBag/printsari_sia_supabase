-- ============================================================================
-- ADD MISSING TABLES TO MATCH PAPER DESIGN
-- ============================================================================

-- Add is_active to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_active boolean NOT NULL DEFAULT true;

-- Add selling_price to products
ALTER TABLE products ADD COLUMN IF NOT EXISTS selling_price numeric(12, 2);

-- ============================================================================
-- LOGIN HISTORY TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS login_history (
  id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  profile_id int8 NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  username text NOT NULL,
  login_time timestamptz NOT NULL DEFAULT now(),
  logout_time timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_login_history_profile_id ON login_history(profile_id);
CREATE INDEX IF NOT EXISTS idx_login_history_login_time ON login_history(login_time);

-- ============================================================================
-- SERVICE SUPPLIES TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS service_supplies (
  id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name text NOT NULL,
  supply_type text NOT NULL,
  paper_size text,
  purchase_price numeric(12, 2) NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_service_supplies_supply_type ON service_supplies(supply_type);

CREATE TRIGGER update_service_supplies_updated_at BEFORE UPDATE ON service_supplies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- MACHINES TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS machines (
  id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service_id int8 REFERENCES print_services(id) ON DELETE SET NULL,
  name text NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_machines_service_id ON machines(service_id);

CREATE TRIGGER update_machines_updated_at BEFORE UPDATE ON machines
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- STOCK_IN TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS stock_in (
  id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  product_id int8 REFERENCES products(id) ON DELETE SET NULL,
  service_supply_id int8 REFERENCES service_supplies(id) ON DELETE SET NULL,
  user_id int8 NOT NULL REFERENCES profiles(id),
  expense_id int8 REFERENCES expenses(id) ON DELETE SET NULL,
  purchase_price numeric(12, 2) NOT NULL,
  quantity_added numeric(12, 2) NOT NULL,
  expiry_date date,
  stock_in_date timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_stock_in_product_id ON stock_in(product_id);
CREATE INDEX IF NOT EXISTS idx_stock_in_service_supply_id ON stock_in(service_supply_id);
CREATE INDEX IF NOT EXISTS idx_stock_in_user_id ON stock_in(user_id);
CREATE INDEX IF NOT EXISTS idx_stock_in_stock_in_date ON stock_in(stock_in_date);

-- ============================================================================
-- STOCK_OUT TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS stock_out (
  id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  transaction_id int8 REFERENCES transactions(id) ON DELETE SET NULL,
  transaction_item_id int8 REFERENCES transaction_items(id) ON DELETE SET NULL,
  product_id int8 REFERENCES products(id) ON DELETE SET NULL,
  service_supply_id int8 REFERENCES service_supplies(id) ON DELETE SET NULL,
  inventory_item_id int8 REFERENCES inventory_items(id) ON DELETE SET NULL,
  user_id int8 NOT NULL REFERENCES profiles(id),
  quantity_removed numeric(12, 2) NOT NULL,
  stock_out_type text NOT NULL DEFAULT 'sale',
  stock_out_date timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_stock_out_transaction_id ON stock_out(transaction_id);
CREATE INDEX IF NOT EXISTS idx_stock_out_product_id ON stock_out(product_id);
CREATE INDEX IF NOT EXISTS idx_stock_out_inventory_item_id ON stock_out(inventory_item_id);
CREATE INDEX IF NOT EXISTS idx_stock_out_stock_out_date ON stock_out(stock_out_date);

-- Add stock_in_id reference to inventory_items
ALTER TABLE inventory_items ADD COLUMN IF NOT EXISTS stock_in_id int8 REFERENCES stock_in(id) ON DELETE SET NULL;

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE login_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_supplies ENABLE ROW LEVEL SECURITY;
ALTER TABLE machines ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_in ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_out ENABLE ROW LEVEL SECURITY;

-- login_history
CREATE POLICY "Authenticated users can view login history"
  ON login_history FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can insert login history"
  ON login_history FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update login history"
  ON login_history FOR UPDATE TO authenticated USING (true);

-- service_supplies
CREATE POLICY "Authenticated users can view service supplies"
  ON service_supplies FOR SELECT TO authenticated USING (true);
CREATE POLICY "Owners can create service supplies"
  ON service_supplies FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "Owners can update service supplies"
  ON service_supplies FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "Owners can delete service supplies"
  ON service_supplies FOR DELETE TO authenticated USING (public.is_owner());

-- machines
CREATE POLICY "Authenticated users can view machines"
  ON machines FOR SELECT TO authenticated USING (true);
CREATE POLICY "Owners can create machines"
  ON machines FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "Owners can update machines"
  ON machines FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "Owners can delete machines"
  ON machines FOR DELETE TO authenticated USING (public.is_owner());

-- stock_in
CREATE POLICY "Authenticated users can view stock_in"
  ON stock_in FOR SELECT TO authenticated USING (true);
CREATE POLICY "Owners can create stock_in"
  ON stock_in FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "Owners can update stock_in"
  ON stock_in FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "Owners can delete stock_in"
  ON stock_in FOR DELETE TO authenticated USING (public.is_owner());

-- stock_out
CREATE POLICY "Authenticated users can view stock_out"
  ON stock_out FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated users can create stock_out"
  ON stock_out FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Owners can update stock_out"
  ON stock_out FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "Owners can delete stock_out"
  ON stock_out FOR DELETE TO authenticated USING (public.is_owner());
