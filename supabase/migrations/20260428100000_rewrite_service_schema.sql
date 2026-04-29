-- ============================================================================
-- Rewrite service schema to match ERD:
--   Service → Service_Type → Service_Type_Cost
--   Machine.service_id FK → Service
--   Product: drop FK category, add string fields
--   ServiceSupply: drop unit
-- ============================================================================

-- 1. Drop old lookup tables and print_services (cascade handles FKs)
DROP TABLE IF EXISTS print_services CASCADE;
DROP TABLE IF EXISTS paper_sizes CASCADE;
DROP TABLE IF EXISTS color_modes CASCADE;
DROP TABLE IF EXISTS print_orientations CASCADE;
DROP TABLE IF EXISTS print_finishes CASCADE;

-- 2. Modify products table
--    Drop old FK columns
ALTER TABLE products DROP COLUMN IF EXISTS category_id;
ALTER TABLE products DROP COLUMN IF EXISTS description;
ALTER TABLE products DROP COLUMN IF EXISTS perishable;
ALTER TABLE products DROP COLUMN IF EXISTS sku;
ALTER TABLE products DROP COLUMN IF EXISTS barcode;
ALTER TABLE products DROP COLUMN IF EXISTS supplier;
--    Add new string fields
ALTER TABLE products ADD COLUMN IF NOT EXISTS product_category TEXT NOT NULL DEFAULT '';
ALTER TABLE products ADD COLUMN IF NOT EXISTS product_type TEXT NOT NULL DEFAULT '';

-- 3. Modify service_supplies table — drop unit column
ALTER TABLE service_supplies DROP COLUMN IF EXISTS unit;

-- 4. Create services table
CREATE TABLE IF NOT EXISTS services (
  id        INT8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name      TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Trigger: updated_at auto-update
CREATE TRIGGER set_updated_at_services
  BEFORE UPDATE ON services
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5. Add service_id to machines
ALTER TABLE machines ADD COLUMN IF NOT EXISTS service_id INT8 REFERENCES services(id) ON DELETE SET NULL;

-- 6. Create service_types table
CREATE TABLE IF NOT EXISTS service_types (
  id               INT8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service_id       INT8 REFERENCES services(id) ON DELETE CASCADE,
  service_supply_id INT8 REFERENCES service_supplies(id) ON DELETE SET NULL,
  machine_id       INT8 REFERENCES machines(id) ON DELETE SET NULL,
  name             TEXT NOT NULL,
  paper_size       TEXT,
  color_mode       TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_service_types
  BEFORE UPDATE ON service_types
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 7. Create service_type_costs table
CREATE TABLE IF NOT EXISTS service_type_costs (
  id                   INT8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service_type_id      INT8 NOT NULL REFERENCES service_types(id) ON DELETE CASCADE,
  service_supply_cost  FLOAT NOT NULL DEFAULT 0,
  ink_cost             FLOAT NOT NULL DEFAULT 0,
  electricity_cost     FLOAT NOT NULL DEFAULT 0,
  labor_cost           FLOAT NOT NULL DEFAULT 0,
  service_total_cost   FLOAT GENERATED ALWAYS AS (service_supply_cost + ink_cost + electricity_cost + labor_cost) STORED,
  service_selling_price FLOAT NOT NULL DEFAULT 0,
  last_updated         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 8. Update print_orders to reference service_types instead of print_services
ALTER TABLE print_orders DROP COLUMN IF EXISTS service_id;
ALTER TABLE print_orders ADD COLUMN IF NOT EXISTS service_type_id INT8 REFERENCES service_types(id) ON DELETE SET NULL;

-- ============================================================================
-- RLS policies for new tables
-- ============================================================================

ALTER TABLE services ENABLE ROW LEVEL SECURITY;
CREATE POLICY "services_select" ON services FOR SELECT USING (true);
CREATE POLICY "services_insert" ON services FOR INSERT WITH CHECK (public.is_owner());
CREATE POLICY "services_update" ON services FOR UPDATE USING (public.is_owner());
CREATE POLICY "services_delete" ON services FOR DELETE USING (public.is_owner());

ALTER TABLE service_types ENABLE ROW LEVEL SECURITY;
CREATE POLICY "service_types_select" ON service_types FOR SELECT USING (true);
CREATE POLICY "service_types_insert" ON service_types FOR INSERT WITH CHECK (public.is_owner());
CREATE POLICY "service_types_update" ON service_types FOR UPDATE USING (public.is_owner());
CREATE POLICY "service_types_delete" ON service_types FOR DELETE USING (public.is_owner());

ALTER TABLE service_type_costs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "service_type_costs_select" ON service_type_costs FOR SELECT USING (true);
CREATE POLICY "service_type_costs_insert" ON service_type_costs FOR INSERT WITH CHECK (public.is_owner());
CREATE POLICY "service_type_costs_update" ON service_type_costs FOR UPDATE USING (public.is_owner());
CREATE POLICY "service_type_costs_delete" ON service_type_costs FOR DELETE USING (public.is_owner());
