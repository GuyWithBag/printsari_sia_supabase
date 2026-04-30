-- ============================================================================
-- Restore services / service_types / service_type_costs hierarchy
-- Previously dropped in 20260429000000_simplify_service_schema.sql
-- ============================================================================

-- 1. Re-create services table
CREATE TABLE IF NOT EXISTS services (
  id         INT8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name       TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_services
  BEFORE UPDATE ON services
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 2. Add service_id to machines (one machine → one primary service)
ALTER TABLE machines ADD COLUMN IF NOT EXISTS service_id INT8 REFERENCES services(id) ON DELETE SET NULL;

-- 3. Re-create service_types table
CREATE TABLE IF NOT EXISTS service_types (
  id                INT8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service_id        INT8 REFERENCES services(id) ON DELETE CASCADE,
  service_supply_id INT8 REFERENCES service_supplies(id) ON DELETE SET NULL,
  machine_id        INT8 REFERENCES machines(id) ON DELETE SET NULL,
  name              TEXT NOT NULL,
  paper_size        TEXT,
  color_mode        TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER set_updated_at_service_types
  BEFORE UPDATE ON service_types
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 4. Re-create service_type_costs table
CREATE TABLE IF NOT EXISTS service_type_costs (
  id                    INT8 PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  service_type_id       INT8 NOT NULL REFERENCES service_types(id) ON DELETE CASCADE,
  service_supply_cost   FLOAT NOT NULL DEFAULT 0,
  ink_cost              FLOAT NOT NULL DEFAULT 0,
  electricity_cost      FLOAT NOT NULL DEFAULT 0,
  labor_cost            FLOAT NOT NULL DEFAULT 0,
  service_total_cost    FLOAT GENERATED ALWAYS AS (service_supply_cost + ink_cost + electricity_cost + labor_cost) STORED,
  service_selling_price FLOAT NOT NULL DEFAULT 0,
  last_updated          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 5. Update print_orders: drop service_supply_id, add service_type_id
ALTER TABLE print_orders DROP COLUMN IF EXISTS service_supply_id;
ALTER TABLE print_orders ADD COLUMN IF NOT EXISTS service_type_id INT8 REFERENCES service_types(id) ON DELETE SET NULL;

-- 6. RLS policies
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
