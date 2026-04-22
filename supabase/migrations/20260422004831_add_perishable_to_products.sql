-- Migration: Add perishable column to products
-- Products that are not perishable (e.g. stationery, non-food items) will not
-- show an expiry date in the POS terminal. Defaults to TRUE to preserve
-- existing behaviour for all current rows.

ALTER TABLE products
  ADD COLUMN IF NOT EXISTS perishable BOOLEAN NOT NULL DEFAULT TRUE;
