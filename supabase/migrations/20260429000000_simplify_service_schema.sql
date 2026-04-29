-- ============================================================================
-- Simplify service schema:
--   - Add selling_price to service_supplies
--   - Rename retail_price → purchase_price on inventory_items
--   - Add is_archived to products
--   - Update print_orders to use service_supply_id instead of service_type_id
--   - Drop services, service_types, service_type_costs tables
--   - Drop service_id from machines
-- ============================================================================

-- 1. Add selling_price to service_supplies
ALTER TABLE service_supplies ADD COLUMN IF NOT EXISTS selling_price FLOAT NOT NULL DEFAULT 0;

-- 2. Rename retail_price → purchase_price on inventory_items
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'inventory_items' AND column_name = 'retail_price'
  ) THEN
    ALTER TABLE inventory_items RENAME COLUMN retail_price TO purchase_price;
  END IF;
END $$;

-- 3. Add is_archived to products
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT false;

-- 4. Update print_orders: drop service_type_id, add service_supply_id
ALTER TABLE print_orders DROP COLUMN IF EXISTS service_type_id;
ALTER TABLE print_orders ADD COLUMN IF NOT EXISTS service_supply_id INT8 REFERENCES service_supplies(id) ON DELETE SET NULL;

-- 5. Drop simplified-away tables (cascade removes FKs pointing to them)
DROP TABLE IF EXISTS service_type_costs CASCADE;
DROP TABLE IF EXISTS service_types CASCADE;
DROP TABLE IF EXISTS services CASCADE;

-- 6. Drop service_id from machines (was referencing services)
ALTER TABLE machines DROP COLUMN IF EXISTS service_id;
