-- ============================================================================
-- FIX MACHINE-TO-SERVICE RELATIONSHIP DIRECTION
-- ============================================================================
-- The original migration had machines.service_id -> print_services (backwards).
-- Correct design: one machine can handle MANY print services.
-- So the FK belongs on print_services.machine_id -> machines.
-- ============================================================================

-- Step 1: Add machine_id to print_services
ALTER TABLE print_services
  ADD COLUMN IF NOT EXISTS machine_id int8 REFERENCES machines(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_print_services_machine_id ON print_services(machine_id);

-- Step 2: Remove the backwards service_id from machines
DROP INDEX IF EXISTS idx_machines_service_id;
ALTER TABLE machines DROP COLUMN IF EXISTS service_id;
