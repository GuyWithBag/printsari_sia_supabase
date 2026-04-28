-- ============================================================================
-- Migration: Vendors, role rename, unit on service_supplies
-- Date: 2026-04-27
--
-- Changes:
--   1. Create vendors table + seed PrintSari Corner
--   2. Add vendor_id FK to expenses
--   3. Rename user_roles 'owner' → 'manager', add new 'owner' (super admin)
--   4. Update is_owner() to accept both owner and manager roles
--   5. Add unit text column to service_supplies
--   6. Add 'purchases' expense category
-- ============================================================================

-- ============================================================================
-- 1. VENDORS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS vendors (
  id int8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name text NOT NULL,
  contact_number text,
  email text,
  address text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_vendors_name ON vendors(name);

CREATE TRIGGER update_vendors_updated_at BEFORE UPDATE ON vendors
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE vendors ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view vendors"
  ON vendors FOR SELECT TO authenticated USING (true);
CREATE POLICY "Owners can create vendors"
  ON vendors FOR INSERT TO authenticated WITH CHECK (public.is_owner());
CREATE POLICY "Owners can update vendors"
  ON vendors FOR UPDATE TO authenticated USING (public.is_owner());
CREATE POLICY "Owners can delete vendors"
  ON vendors FOR DELETE TO authenticated USING (public.is_owner());

-- Seed default vendor
INSERT INTO vendors (name, contact_number, email, address)
VALUES ('PrintSari Corner', NULL, NULL, 'Magpet, North Cotabato')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 2. ADD vendor_id TO EXPENSES
-- ============================================================================

ALTER TABLE expenses
  ADD COLUMN IF NOT EXISTS vendor_id int8 REFERENCES vendors(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_expenses_vendor_id ON expenses(vendor_id);

-- ============================================================================
-- 3. RENAME ROLE 'owner' → 'manager', ADD NEW 'owner' (super admin, id=3)
-- ============================================================================

-- Rename existing 'owner' role to 'manager'
UPDATE user_roles SET role_name = 'manager' WHERE role_name = 'owner';

-- Insert new 'owner' super-admin role (will get next identity id)
INSERT INTO user_roles (role_name)
VALUES ('owner')
ON CONFLICT (role_name) DO NOTHING;

-- ============================================================================
-- 4. UPDATE is_owner() TO ACCEPT BOTH 'owner' AND 'manager'
-- ============================================================================

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

-- ============================================================================
-- 5. ADD unit COLUMN TO service_supplies
-- ============================================================================

ALTER TABLE service_supplies
  ADD COLUMN IF NOT EXISTS unit text;

-- ============================================================================
-- 6. ADD 'purchases' EXPENSE CATEGORY
-- ============================================================================

INSERT INTO expense_categories (category_name)
VALUES ('purchases')
ON CONFLICT (category_name) DO NOTHING;
