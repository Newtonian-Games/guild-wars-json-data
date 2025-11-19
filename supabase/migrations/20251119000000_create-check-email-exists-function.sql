-- Function to check if an email exists in auth.users
-- This is safe to call from the client since it only returns a boolean
CREATE OR REPLACE FUNCTION check_email_exists(email_to_check TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM auth.users
    WHERE email = email_to_check
  );
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION check_email_exists(TEXT) TO authenticated;

-- Also grant to anon so login screen can check before authentication
GRANT EXECUTE ON FUNCTION check_email_exists(TEXT) TO anon;






