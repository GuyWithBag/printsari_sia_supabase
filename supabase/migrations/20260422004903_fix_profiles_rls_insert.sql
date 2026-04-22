-- Migration: Fix RLS on profiles so that owners can create cashier accounts
--
-- Problem: When an owner calls supabase.auth.signUp() and then inserts into
-- profiles, the INSERT is blocked because the only existing INSERT policy
-- requires auth.uid() = user_id (i.e. the row owner inserts their own profile).
-- A newly signed-up user has a different uid than the owner performing the
-- action, so the policy rejects it.
--
-- Fix: Add a policy that allows any authenticated user whose own profile has
-- the 'owner' role to insert a profile row for someone else.

DROP POLICY IF EXISTS "owners_can_insert_profiles" ON profiles;

CREATE POLICY "owners_can_insert_profiles"
  ON profiles
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles AS p
      INNER JOIN user_roles AS r ON r.id = p.role_id
      WHERE p.user_id = auth.uid()
        AND r.role_name = 'owner'
    )
  );
