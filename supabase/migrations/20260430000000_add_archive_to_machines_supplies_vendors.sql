-- Add is_archived soft-delete to machines, service_supplies, and vendors
ALTER TABLE machines        ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE service_supplies ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE vendors          ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT false;
