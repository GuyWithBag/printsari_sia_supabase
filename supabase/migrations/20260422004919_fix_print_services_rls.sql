-- Migration: Fix RLS on print_services so that insert + select-back works
--
-- Problem: createPrintService() does:
--   .insert(...).select('*, paper_sizes(*), ...').single()
-- The INSERT succeeds but the immediate SELECT returns 0 rows (PGRST116)
-- because the SELECT policy blocks the authenticated user from reading the
-- newly inserted row.
--
-- Fix: Ensure authenticated users can SELECT all print_services rows, and
-- that owners can INSERT / UPDATE / DELETE them.

-- SELECT: all authenticated users (cashiers need to read services in POS)
DROP POLICY IF EXISTS "authenticated_can_select_print_services" ON print_services;

CREATE POLICY "authenticated_can_select_print_services"
  ON print_services
  FOR SELECT
  USING (auth.role() = 'authenticated');

-- INSERT: owners only
DROP POLICY IF EXISTS "owners_can_insert_print_services" ON print_services;

CREATE POLICY "owners_can_insert_print_services"
  ON print_services
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles AS p
      INNER JOIN user_roles AS r ON r.id = p.role_id
      WHERE p.user_id = auth.uid()
        AND r.role_name = 'owner'
    )
  );

-- UPDATE: owners only
DROP POLICY IF EXISTS "owners_can_update_print_services" ON print_services;

CREATE POLICY "owners_can_update_print_services"
  ON print_services
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles AS p
      INNER JOIN user_roles AS r ON r.id = p.role_id
      WHERE p.user_id = auth.uid()
        AND r.role_name = 'owner'
    )
  );

-- DELETE: owners only
DROP POLICY IF EXISTS "owners_can_delete_print_services" ON print_services;

CREATE POLICY "owners_can_delete_print_services"
  ON print_services
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM profiles AS p
      INNER JOIN user_roles AS r ON r.id = p.role_id
      WHERE p.user_id = auth.uid()
        AND r.role_name = 'owner'
    )
  );
