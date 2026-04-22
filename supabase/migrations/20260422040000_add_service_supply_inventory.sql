-- ============================================================================
-- ADD SERVICE SUPPLY INVENTORY SUPPORT
-- ============================================================================
-- inventory_items.product_id was NOT NULL — supply rows could not exist.
-- Fix: make product_id nullable, add service_supply_id column.
-- One row = one product OR one service supply (enforced by CHECK).
-- Also add service_supply_id FK to print_services so each service
-- knows which supply it consumes (1 unit per page).
-- ============================================================================

-- Step 1: Make product_id nullable so supply rows can have product_id = NULL
ALTER TABLE inventory_items ALTER COLUMN product_id DROP NOT NULL;

-- Step 2: Add service_supply_id to inventory_items
ALTER TABLE inventory_items
  ADD COLUMN IF NOT EXISTS service_supply_id int8
  REFERENCES service_supplies(id) ON DELETE CASCADE;

-- Unique index for supply items (partial — only where service_supply_id IS NOT NULL)
CREATE UNIQUE INDEX IF NOT EXISTS idx_inventory_items_service_supply_id
  ON inventory_items(service_supply_id)
  WHERE service_supply_id IS NOT NULL;

-- Constraint: exactly one of product_id or service_supply_id must be set
ALTER TABLE inventory_items
  ADD CONSTRAINT chk_inventory_item_type CHECK (
    (product_id IS NOT NULL AND service_supply_id IS NULL) OR
    (product_id IS NULL AND service_supply_id IS NOT NULL)
  );

-- Step 3: Add service_supply_id to print_services
-- Each print service can optionally link to one supply it consumes per page
ALTER TABLE print_services
  ADD COLUMN IF NOT EXISTS service_supply_id int8
  REFERENCES service_supplies(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_print_services_service_supply_id
  ON print_services(service_supply_id);
