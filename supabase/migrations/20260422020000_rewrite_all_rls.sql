-- ============================================================================
-- REWRITE ALL RLS POLICIES (clean slate)
--
-- Root-cause fix: supabase.auth.signUp() in Flutter automatically signs in
-- the new user, replacing the owner's session. When the app then inserts into
-- "profiles", auth.uid() is the NEW user (who has no profile row yet), so
-- every is_owner() check returns false → INSERT denied.
--
-- Fix: profiles INSERT uses `user_id = auth.uid()` so the newly-authenticated
-- user can always insert their own profile row.  All other owner-gated tables
-- keep is_owner() as before.
-- ============================================================================

-- ============================================================================
-- DROP ALL EXISTING POLICIES
-- ============================================================================

-- profiles
DROP POLICY IF EXISTS "Authenticated users can view all profiles"    ON profiles;
DROP POLICY IF EXISTS "Users can update own profile"                 ON profiles;
DROP POLICY IF EXISTS "Owners can create profiles"                   ON profiles;
DROP POLICY IF EXISTS "Owners can delete profiles"                   ON profiles;
DROP POLICY IF EXISTS "owners_can_insert_profiles"                   ON profiles;

-- customers
DROP POLICY IF EXISTS "Authenticated users can view customers"       ON customers;
DROP POLICY IF EXISTS "Authenticated users can create customers"     ON customers;
DROP POLICY IF EXISTS "Authenticated users can update customers"     ON customers;
DROP POLICY IF EXISTS "Owners can delete customers"                  ON customers;

-- products
DROP POLICY IF EXISTS "Authenticated users can view products"        ON products;
DROP POLICY IF EXISTS "Owners can create products"                   ON products;
DROP POLICY IF EXISTS "Owners can update products"                   ON products;
DROP POLICY IF EXISTS "Owners can delete products"                   ON products;

-- inventory_items
DROP POLICY IF EXISTS "Authenticated users can view inventory"       ON inventory_items;
DROP POLICY IF EXISTS "Owners can create inventory"                  ON inventory_items;
DROP POLICY IF EXISTS "Authenticated users can update inventory"     ON inventory_items;
DROP POLICY IF EXISTS "Owners can delete inventory"                  ON inventory_items;

-- print_services
DROP POLICY IF EXISTS "Authenticated users can view print services"  ON print_services;
DROP POLICY IF EXISTS "Owners can create print services"             ON print_services;
DROP POLICY IF EXISTS "Owners can update print services"             ON print_services;
DROP POLICY IF EXISTS "Owners can delete print services"             ON print_services;

-- transactions
DROP POLICY IF EXISTS "Authenticated users can view transactions"                    ON transactions;
DROP POLICY IF EXISTS "Authenticated users can create transactions"                  ON transactions;
DROP POLICY IF EXISTS "Users can update own transactions, owners can update all"     ON transactions;
DROP POLICY IF EXISTS "Owners can delete transactions"                               ON transactions;

-- transaction_items
DROP POLICY IF EXISTS "Authenticated users can view transaction items"   ON transaction_items;
DROP POLICY IF EXISTS "Authenticated users can create transaction items" ON transaction_items;
DROP POLICY IF EXISTS "Authenticated users can update transaction items" ON transaction_items;
DROP POLICY IF EXISTS "Owners can delete transaction items"              ON transaction_items;

-- print_orders
DROP POLICY IF EXISTS "Authenticated users can view print orders"   ON print_orders;
DROP POLICY IF EXISTS "Authenticated users can create print orders" ON print_orders;
DROP POLICY IF EXISTS "Authenticated users can update print orders" ON print_orders;
DROP POLICY IF EXISTS "Owners can delete print orders"              ON print_orders;

-- expenses
DROP POLICY IF EXISTS "Authenticated users can view expenses"   ON expenses;
DROP POLICY IF EXISTS "Authenticated users can create expenses" ON expenses;
DROP POLICY IF EXISTS "Owners can update expenses"              ON expenses;
DROP POLICY IF EXISTS "Owners can delete expenses"              ON expenses;

-- activity_logs
DROP POLICY IF EXISTS "Authenticated users can view activity logs"   ON activity_logs;
DROP POLICY IF EXISTS "Authenticated users can create activity logs" ON activity_logs;

-- financial_reports
DROP POLICY IF EXISTS "Authenticated users can view financial reports" ON financial_reports;
DROP POLICY IF EXISTS "Owners can create financial reports"            ON financial_reports;
DROP POLICY IF EXISTS "Owners can update financial reports"            ON financial_reports;
DROP POLICY IF EXISTS "Owners can delete financial reports"            ON financial_reports;

-- metrics tables
DROP POLICY IF EXISTS "Authenticated users can view daily_metrics"        ON daily_metrics;
DROP POLICY IF EXISTS "Authenticated users can view weekly_metrics"       ON weekly_metrics;
DROP POLICY IF EXISTS "Authenticated users can view monthly_metrics"      ON monthly_metrics;
DROP POLICY IF EXISTS "Authenticated users can view trend_data_points"    ON trend_data_points;
DROP POLICY IF EXISTS "Authenticated users can view department_revenues"  ON department_revenues;
DROP POLICY IF EXISTS "Authenticated users can view expenses_by_category" ON expenses_by_category;
DROP POLICY IF EXISTS "Owners can create daily_metrics"        ON daily_metrics;
DROP POLICY IF EXISTS "Owners can create weekly_metrics"       ON weekly_metrics;
DROP POLICY IF EXISTS "Owners can create monthly_metrics"      ON monthly_metrics;
DROP POLICY IF EXISTS "Owners can create trend_data_points"    ON trend_data_points;
DROP POLICY IF EXISTS "Owners can create department_revenues"  ON department_revenues;
DROP POLICY IF EXISTS "Owners can create expenses_by_category" ON expenses_by_category;
DROP POLICY IF EXISTS "Owners can update daily_metrics"        ON daily_metrics;
DROP POLICY IF EXISTS "Owners can update weekly_metrics"       ON weekly_metrics;
DROP POLICY IF EXISTS "Owners can update monthly_metrics"      ON monthly_metrics;
DROP POLICY IF EXISTS "Owners can update trend_data_points"    ON trend_data_points;
DROP POLICY IF EXISTS "Owners can update department_revenues"  ON department_revenues;
DROP POLICY IF EXISTS "Owners can update expenses_by_category" ON expenses_by_category;
DROP POLICY IF EXISTS "Owners can delete daily_metrics"        ON daily_metrics;
DROP POLICY IF EXISTS "Owners can delete weekly_metrics"       ON weekly_metrics;
DROP POLICY IF EXISTS "Owners can delete monthly_metrics"      ON monthly_metrics;
DROP POLICY IF EXISTS "Owners can delete trend_data_points"    ON trend_data_points;
DROP POLICY IF EXISTS "Owners can delete department_revenues"  ON department_revenues;
DROP POLICY IF EXISTS "Owners can delete expenses_by_category" ON expenses_by_category;

-- lookup tables
DROP POLICY IF EXISTS "Authenticated users can read activity_actions"    ON activity_actions;
DROP POLICY IF EXISTS "Authenticated users can read expense_categories"  ON expense_categories;
DROP POLICY IF EXISTS "Authenticated users can read expense_sources"     ON expense_sources;
DROP POLICY IF EXISTS "Authenticated users can read paper_sizes"         ON paper_sizes;
DROP POLICY IF EXISTS "Authenticated users can read color_modes"         ON color_modes;
DROP POLICY IF EXISTS "Authenticated users can read print_orientations"  ON print_orientations;
DROP POLICY IF EXISTS "Authenticated users can read print_finishes"      ON print_finishes;
DROP POLICY IF EXISTS "Authenticated users can read product_categories"  ON product_categories;
DROP POLICY IF EXISTS "Authenticated users can read transaction_statuses" ON transaction_statuses;
DROP POLICY IF EXISTS "Authenticated users can read payment_methods"     ON payment_methods;
DROP POLICY IF EXISTS "Authenticated users can read user_roles"          ON user_roles;
DROP POLICY IF EXISTS "Authenticated users can read report_periods"      ON report_periods;

-- new tables (from add_missing_tables migration)
DROP POLICY IF EXISTS "Authenticated users can view login history"  ON login_history;
DROP POLICY IF EXISTS "Authenticated users can insert login history" ON login_history;
DROP POLICY IF EXISTS "Authenticated users can update login history" ON login_history;
DROP POLICY IF EXISTS "Authenticated users can view service supplies" ON service_supplies;
DROP POLICY IF EXISTS "Owners can create service supplies"           ON service_supplies;
DROP POLICY IF EXISTS "Owners can update service supplies"           ON service_supplies;
DROP POLICY IF EXISTS "Owners can delete service supplies"           ON service_supplies;
DROP POLICY IF EXISTS "Authenticated users can view machines"        ON machines;
DROP POLICY IF EXISTS "Owners can create machines"                   ON machines;
DROP POLICY IF EXISTS "Owners can update machines"                   ON machines;
DROP POLICY IF EXISTS "Owners can delete machines"                   ON machines;
DROP POLICY IF EXISTS "Authenticated users can view stock_in"        ON stock_in;
DROP POLICY IF EXISTS "Owners can create stock_in"                   ON stock_in;
DROP POLICY IF EXISTS "Owners can update stock_in"                   ON stock_in;
DROP POLICY IF EXISTS "Owners can delete stock_in"                   ON stock_in;
DROP POLICY IF EXISTS "Authenticated users can view stock_out"       ON stock_out;
DROP POLICY IF EXISTS "Authenticated users can create stock_out"     ON stock_out;
DROP POLICY IF EXISTS "Owners can update stock_out"                  ON stock_out;
DROP POLICY IF EXISTS "Owners can delete stock_out"                  ON stock_out;

-- ============================================================================
-- RECREATE is_owner() HELPER (idempotent)
-- ============================================================================

CREATE OR REPLACE FUNCTION public.is_owner()
RETURNS boolean AS $$
  SELECT EXISTS (
    SELECT 1
    FROM profiles p
    JOIN user_roles ur ON p.role_id = ur.id
    WHERE p.user_id = auth.uid()
      AND ur.role_name = 'owner'
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

-- ============================================================================
-- LOOKUP TABLES — read-only for all authenticated users
-- ============================================================================

CREATE POLICY "lookup_select" ON activity_actions      FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON expense_categories    FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON expense_sources       FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON paper_sizes           FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON color_modes           FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON print_orientations    FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON print_finishes        FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON product_categories    FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON transaction_statuses  FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON payment_methods       FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON user_roles            FOR SELECT TO authenticated USING (true);
CREATE POLICY "lookup_select" ON report_periods        FOR SELECT TO authenticated USING (true);

-- ============================================================================
-- PROFILES
-- ============================================================================

-- Anyone authenticated can see all profiles (needed for cashier names, etc.)
CREATE POLICY "profiles_select"
  ON profiles FOR SELECT TO authenticated
  USING (true);

-- KEY FIX: After signUp(), the new user is automatically logged in.
-- We allow the newly-authenticated user to insert their own profile row.
-- The restriction on *who can create auth users* is enforced in the Flutter UI.
CREATE POLICY "profiles_insert"
  ON profiles FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Users can update their own profile; owners can update any profile
-- (needed for deactivate/activate and the edit-user dialog)
CREATE POLICY "profiles_update"
  ON profiles FOR UPDATE TO authenticated
  USING (user_id = auth.uid() OR public.is_owner());

-- Only owners can delete profiles
CREATE POLICY "profiles_delete"
  ON profiles FOR DELETE TO authenticated
  USING (public.is_owner());

-- ============================================================================
-- CUSTOMERS
-- ============================================================================

CREATE POLICY "customers_select" ON customers FOR SELECT TO authenticated USING (true);
CREATE POLICY "customers_insert" ON customers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "customers_update" ON customers FOR UPDATE TO authenticated USING (true);
CREATE POLICY "customers_delete" ON customers FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- PRODUCTS
-- ============================================================================

CREATE POLICY "products_select" ON products FOR SELECT TO authenticated USING (true);
CREATE POLICY "products_insert" ON products FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "products_update" ON products FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "products_delete" ON products FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- INVENTORY ITEMS
-- ============================================================================

CREATE POLICY "inventory_items_select" ON inventory_items FOR SELECT TO authenticated USING (true);
-- Owners stock in; cashiers can also update stock when processing sales
CREATE POLICY "inventory_items_insert" ON inventory_items FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "inventory_items_update" ON inventory_items FOR UPDATE TO authenticated USING (true);
CREATE POLICY "inventory_items_delete" ON inventory_items FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- PRINT SERVICES
-- ============================================================================

CREATE POLICY "print_services_select" ON print_services FOR SELECT TO authenticated USING (true);
CREATE POLICY "print_services_insert" ON print_services FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "print_services_update" ON print_services FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "print_services_delete" ON print_services FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- TRANSACTIONS
-- ============================================================================

CREATE POLICY "transactions_select" ON transactions FOR SELECT TO authenticated USING (true);
CREATE POLICY "transactions_insert" ON transactions FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "transactions_update"
  ON transactions FOR UPDATE TO authenticated
  USING (public.is_owner() OR cashier_id = (SELECT id FROM profiles WHERE user_id = auth.uid()));
CREATE POLICY "transactions_delete" ON transactions FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- TRANSACTION ITEMS
-- ============================================================================

CREATE POLICY "transaction_items_select" ON transaction_items FOR SELECT TO authenticated USING (true);
CREATE POLICY "transaction_items_insert" ON transaction_items FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "transaction_items_update" ON transaction_items FOR UPDATE TO authenticated USING (true);
CREATE POLICY "transaction_items_delete" ON transaction_items FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- PRINT ORDERS
-- ============================================================================

CREATE POLICY "print_orders_select" ON print_orders FOR SELECT TO authenticated USING (true);
CREATE POLICY "print_orders_insert" ON print_orders FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "print_orders_update" ON print_orders FOR UPDATE TO authenticated USING (true);
CREATE POLICY "print_orders_delete" ON print_orders FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- EXPENSES
-- ============================================================================

CREATE POLICY "expenses_select" ON expenses FOR SELECT TO authenticated USING (true);
CREATE POLICY "expenses_insert" ON expenses FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "expenses_update" ON expenses FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "expenses_delete" ON expenses FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- ACTIVITY LOGS (append-only audit trail)
-- ============================================================================

CREATE POLICY "activity_logs_select" ON activity_logs FOR SELECT TO authenticated USING (true);
CREATE POLICY "activity_logs_insert" ON activity_logs FOR INSERT TO authenticated WITH CHECK (true);

-- ============================================================================
-- FINANCIAL REPORTS + METRICS
-- ============================================================================

CREATE POLICY "financial_reports_select" ON financial_reports FOR SELECT TO authenticated USING (true);
CREATE POLICY "financial_reports_insert" ON financial_reports FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "financial_reports_update" ON financial_reports FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "financial_reports_delete" ON financial_reports FOR DELETE TO authenticated USING (public.is_owner());

CREATE POLICY "daily_metrics_select"        ON daily_metrics       FOR SELECT TO authenticated USING (true);
CREATE POLICY "weekly_metrics_select"       ON weekly_metrics      FOR SELECT TO authenticated USING (true);
CREATE POLICY "monthly_metrics_select"      ON monthly_metrics     FOR SELECT TO authenticated USING (true);
CREATE POLICY "trend_data_points_select"    ON trend_data_points   FOR SELECT TO authenticated USING (true);
CREATE POLICY "department_revenues_select"  ON department_revenues FOR SELECT TO authenticated USING (true);
CREATE POLICY "expenses_by_category_select" ON expenses_by_category FOR SELECT TO authenticated USING (true);

CREATE POLICY "daily_metrics_insert"        ON daily_metrics       FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "weekly_metrics_insert"       ON weekly_metrics      FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "monthly_metrics_insert"      ON monthly_metrics     FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "trend_data_points_insert"    ON trend_data_points   FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "department_revenues_insert"  ON department_revenues FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "expenses_by_category_insert" ON expenses_by_category FOR INSERT TO authenticated WITH CHECK (public.is_owner());

CREATE POLICY "daily_metrics_update"        ON daily_metrics       FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "weekly_metrics_update"       ON weekly_metrics      FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "monthly_metrics_update"      ON monthly_metrics     FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "trend_data_points_update"    ON trend_data_points   FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "department_revenues_update"  ON department_revenues FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "expenses_by_category_update" ON expenses_by_category FOR UPDATE TO authenticated USING (public.is_owner());

CREATE POLICY "daily_metrics_delete"        ON daily_metrics       FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "weekly_metrics_delete"       ON weekly_metrics      FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "monthly_metrics_delete"      ON monthly_metrics     FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "trend_data_points_delete"    ON trend_data_points   FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "department_revenues_delete"  ON department_revenues FOR DELETE TO authenticated USING (public.is_owner());
CREATE POLICY "expenses_by_category_delete" ON expenses_by_category FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- LOGIN HISTORY
-- ============================================================================

CREATE POLICY "login_history_select" ON login_history FOR SELECT TO authenticated USING (true);
CREATE POLICY "login_history_insert" ON login_history FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "login_history_update" ON login_history FOR UPDATE TO authenticated USING (true);
-- No delete policy — login history is immutable

-- ============================================================================
-- SERVICE SUPPLIES
-- ============================================================================

CREATE POLICY "service_supplies_select" ON service_supplies FOR SELECT TO authenticated USING (true);
CREATE POLICY "service_supplies_insert" ON service_supplies FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "service_supplies_update" ON service_supplies FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "service_supplies_delete" ON service_supplies FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- MACHINES
-- ============================================================================

CREATE POLICY "machines_select" ON machines FOR SELECT TO authenticated USING (true);
CREATE POLICY "machines_insert" ON machines FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "machines_update" ON machines FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "machines_delete" ON machines FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- STOCK_IN
-- ============================================================================

CREATE POLICY "stock_in_select" ON stock_in FOR SELECT TO authenticated USING (true);
-- Allow all authenticated users to create stock_in records
-- (inventory provider calls this from both owner and cashier contexts)
CREATE POLICY "stock_in_insert" ON stock_in FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "stock_in_update" ON stock_in FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "stock_in_delete" ON stock_in FOR DELETE TO authenticated USING (public.is_owner());

-- ============================================================================
-- STOCK_OUT
-- ============================================================================

CREATE POLICY "stock_out_select" ON stock_out FOR SELECT TO authenticated USING (true);
-- Cashiers create stock_out records when completing a sale
CREATE POLICY "stock_out_insert" ON stock_out FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "stock_out_update" ON stock_out FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "stock_out_delete" ON stock_out FOR DELETE TO authenticated USING (public.is_owner());
