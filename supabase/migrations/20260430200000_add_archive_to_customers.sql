-- Add soft-delete support to customers
ALTER TABLE customers ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT false;
