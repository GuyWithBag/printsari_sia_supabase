-- =============================================
-- COMPREHENSIVE MOCK DATA FOR PRINTSARI SIA
-- Users: daniel_owner (owner), jose_manager (manager),
--        4 cashiers (1 inactive)
-- Products: 15 store items (low-stock + out-of-stock included)
-- Transactions: 30 over 30 days (trend chart data)
-- Vendors: 5 suppliers
-- =============================================

-- =============================================
-- 1. AUTH USERS & PROFILES
-- =============================================
DO $$
DECLARE
  owner1_uid   uuid := '00000000-0000-0000-0000-000000000001';
  manager1_uid uuid := '00000000-0000-0000-0000-000000000002';
  cashier1_uid uuid := '00000000-0000-0000-0000-000000000003';
  cashier2_uid uuid := '00000000-0000-0000-0000-000000000004';
  cashier3_uid uuid := '00000000-0000-0000-0000-000000000005';
  cashier4_uid uuid := '00000000-0000-0000-0000-000000000006';
  cashier5_uid uuid := '00000000-0000-0000-0000-000000000007';
  owner_role_id   int8;
  manager_role_id int8;
  cashier_role_id int8;
BEGIN
  SELECT id INTO owner_role_id   FROM user_roles WHERE role_name = 'owner';
  SELECT id INTO manager_role_id FROM user_roles WHERE role_name = 'manager';
  SELECT id INTO cashier_role_id FROM user_roles WHERE role_name = 'cashier';

  INSERT INTO auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, created_at, updated_at,
    raw_app_meta_data, raw_user_meta_data, is_super_admin,
    confirmation_token, recovery_token, email_change, email_change_token_new
  ) VALUES
    ('00000000-0000-0000-0000-000000000000', owner1_uid,   'authenticated', 'authenticated', 'owner1@printsari.internal',   crypt('owner123',   gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{}', false, '', '', '', ''),
    ('00000000-0000-0000-0000-000000000000', manager1_uid, 'authenticated', 'authenticated', 'manager1@printsari.internal', crypt('manager123', gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{}', false, '', '', '', ''),
    ('00000000-0000-0000-0000-000000000000', cashier1_uid, 'authenticated', 'authenticated', 'cashier1@printsari.internal', crypt('cashier123', gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{}', false, '', '', '', ''),
    ('00000000-0000-0000-0000-000000000000', cashier2_uid, 'authenticated', 'authenticated', 'cashier2@printsari.internal', crypt('cashier123', gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{}', false, '', '', '', ''),
    ('00000000-0000-0000-0000-000000000000', cashier3_uid, 'authenticated', 'authenticated', 'cashier3@printsari.internal', crypt('cashier123', gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{}', false, '', '', '', ''),
    ('00000000-0000-0000-0000-000000000000', cashier4_uid, 'authenticated', 'authenticated', 'cashier4@printsari.internal', crypt('cashier123', gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{}', false, '', '', '', ''),
    ('00000000-0000-0000-0000-000000000000', cashier5_uid, 'authenticated', 'authenticated', 'cashier5@printsari.internal', crypt('cashier123', gen_salt('bf')), NOW(), NOW(), NOW(), '{"provider":"email","providers":["email"]}', '{}', false, '', '', '', '');

  INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, created_at, updated_at, last_sign_in_at) VALUES
    (gen_random_uuid(), owner1_uid,   'owner1@printsari.internal',   jsonb_build_object('sub', owner1_uid::text,   'email', 'owner1@printsari.internal'),   'email', NOW(), NOW(), NOW()),
    (gen_random_uuid(), manager1_uid, 'manager1@printsari.internal', jsonb_build_object('sub', manager1_uid::text, 'email', 'manager1@printsari.internal'), 'email', NOW(), NOW(), NOW()),
    (gen_random_uuid(), cashier1_uid, 'cashier1@printsari.internal', jsonb_build_object('sub', cashier1_uid::text, 'email', 'cashier1@printsari.internal'), 'email', NOW(), NOW(), NOW()),
    (gen_random_uuid(), cashier2_uid, 'cashier2@printsari.internal', jsonb_build_object('sub', cashier2_uid::text, 'email', 'cashier2@printsari.internal'), 'email', NOW(), NOW(), NOW()),
    (gen_random_uuid(), cashier3_uid, 'cashier3@printsari.internal', jsonb_build_object('sub', cashier3_uid::text, 'email', 'cashier3@printsari.internal'), 'email', NOW(), NOW(), NOW()),
    (gen_random_uuid(), cashier4_uid, 'cashier4@printsari.internal', jsonb_build_object('sub', cashier4_uid::text, 'email', 'cashier4@printsari.internal'), 'email', NOW(), NOW(), NOW()),
    (gen_random_uuid(), cashier5_uid, 'cashier5@printsari.internal', jsonb_build_object('sub', cashier5_uid::text, 'email', 'cashier5@printsari.internal'), 'email', NOW(), NOW(), NOW());

  INSERT INTO profiles (user_id, username, role_id, name, phone, address_city, address_province, address_country, is_active) VALUES
    (owner1_uid,   'daniel_owner',  owner_role_id,   'Daniel David Lupase', '09171111001', 'Magpet', 'North Cotabato', 'Philippines', true),
    (manager1_uid, 'jose_manager',  manager_role_id, 'Jose Reyes',          '09171111002', 'Magpet', 'North Cotabato', 'Philippines', true),
    (cashier1_uid, 'maria_cashier', cashier_role_id, 'Maria Santos',        '09171111003', 'Magpet', 'North Cotabato', 'Philippines', true),
    (cashier2_uid, 'pedro_cashier', cashier_role_id, 'Pedro Garcia',        '09171111004', 'Magpet', 'North Cotabato', 'Philippines', true),
    (cashier3_uid, 'ana_cashier',   cashier_role_id, 'Ana Cruz',            '09171111005', 'Magpet', 'North Cotabato', 'Philippines', true),
    (cashier4_uid, 'kevin_cashier', cashier_role_id, 'Kevin Dela Torre',    '09171111006', 'Magpet', 'North Cotabato', 'Philippines', true),
    (cashier5_uid, 'liza_cashier',  cashier_role_id, 'Liza Bautista',       '09171111007', 'Magpet', 'North Cotabato', 'Philippines', false);
END $$;

-- =============================================
-- 2. PRODUCTS (15 items)
--    purchase_price = cost; selling_price = retail
--    LOW STOCK: Mug (stock 3, reorder 5), Scotch Tape (stock 4, reorder 8), Folder Long (stock 3, reorder 5)
--    OUT OF STOCK: Skyflakes Crackers (stock 0)
-- =============================================
INSERT INTO products (name, product_category, product_type, purchase_price, selling_price) VALUES
  ('Yellow Pad Short',       'Stationery',       'Paper',         18.00,  35.00),
  ('Ballpen Black',          'Stationery',       'Writing Tool',   4.00,  12.00),
  ('Correction Tape',        'Stationery',       'Correction',    11.00,  22.00),
  ('Pandesal (pack 12)',     'Food & Beverage',  'Bakery',        25.00,  45.00),
  ('Coffee 3-in-1 sachet',   'Food & Beverage',  'Beverage',       4.00,   8.00),
  ('Mug (ceramic white)',    'Household',        'Drinkware',     60.00, 120.00),
  ('Skyflakes Crackers',     'Food & Beverage',  'Snack',          8.00,  15.00),
  ('Lucky Me Cup Noodles',   'Food & Beverage',  'Instant Meal',  14.00,  25.00),
  ('Scotch Tape',            'Stationery',       'Adhesive',       8.00,  15.00),
  ('Stapler',                'Stationery',       'Binding',       55.00,  95.00),
  ('Folder Long',            'Stationery',       'Filing',         7.00,  12.00),
  ('Mineral Water 500ml',    'Food & Beverage',  'Beverage',      12.00,  20.00),
  ('Coca-Cola 500ml',        'Food & Beverage',  'Beverage',      22.00,  35.00),
  ('Alcohol 70% 250ml',      'Health & Hygiene', 'Sanitizer',     40.00,  65.00),
  ('Notebook Spiral (80L)',  'Stationery',       'Notebook',      30.00,  55.00);

-- =============================================
-- 3. SERVICE SUPPLIES
-- =============================================
-- purchase_price = all-in cost per page (used by checkout expense calc)
-- selling_price  = price charged to customer per page
INSERT INTO service_supplies (name, supply_type, paper_size, purchase_price, selling_price) VALUES
  ('Short Bond Paper (Ream)',   'paper', 'short', 0.33,  3.00),
  ('Long Bond Paper (Ream)',    'paper', 'long',  0.38,  4.00),
  ('A4 Bond Paper (Ream)',      'paper', 'a4',    0.33,  3.00),
  ('Glossy Photo Paper (Pack)', 'paper', 'a4',    4.20, 20.00),
  ('Epson Black Ink (T664)',    'ink',   NULL,    0.20,  0.00),
  ('Epson Cyan Ink (T664)',     'ink',   NULL,    0.50,  0.00),
  ('Epson Magenta Ink (T664)',  'ink',   NULL,    0.50,  0.00),
  ('Epson Yellow Ink (T664)',   'ink',   NULL,    0.50,  0.00);

-- =============================================
-- 4. SERVICES
-- =============================================
INSERT INTO services (name) VALUES
  ('B&W Document Printing'),
  ('Color Document Printing'),
  ('Photo Printing');

-- =============================================
-- 5. MACHINES
-- =============================================
INSERT INTO machines (name, is_active) VALUES
  ('Epson L3110 (BW/Color)', true),
  ('Canon PIXMA iP110',      true),
  ('Epson L120 (Backup)',    false);

-- =============================================
-- 7. CUSTOMERS (10)
-- =============================================
INSERT INTO customers (name, email, phone, address, notes) VALUES
  ('Juan Dela Cruz',    'juan@email.com',        '09181112222', 'Brgy. Panangan, Magpet, N. Cotabato',        'Regular customer'),
  ('Ana Reyes',         'ana.reyes@email.com',   '09193334444', 'Brgy. Datu Ladayon, Magpet, N. Cotabato',   'Student - bulk printing'),
  ('Pedro Garcia',      'pedro.g@email.com',     '09205556666', 'Brgy. Sto. Niño, Magpet, N. Cotabato',      NULL),
  ('Rosa Mendoza',      'rosa.m@email.com',      '09217778888', 'Brgy. Palacat, Magpet, N. Cotabato',        'Nearby sari-sari owner'),
  ('Carlos Tan',        'carlos.t@email.com',    '09229990000', 'Brgy. Malugon, Magpet, N. Cotabato',        'Office supplies buyer'),
  ('Nena Villanueva',   'nena.v@email.com',      '09231231234', 'Brgy. New Pontevedra, Magpet, N. Cotabato', 'Teacher'),
  ('Rodrigo Bautista',  'rod.b@email.com',       '09342342345', 'Brgy. Dado, Magpet, N. Cotabato',           NULL),
  ('Carla Fernandez',   'carla.f@email.com',     '09453453456', 'Brgy. Kibugtongan, Magpet, N. Cotabato',    'Thesis printing - bulk'),
  ('Manny Torres',      'manny.t@email.com',     '09564564567', 'Brgy. Banayal, Magpet, N. Cotabato',        NULL),
  ('Grace Ocampo',      'grace.o@email.com',     '09675675678', 'Brgy. New Maasin, Magpet, N. Cotabato',     'Monthly bulk buyer');

-- =============================================
-- 7. ADDITIONAL VENDORS
--    (PrintSari Corner is already seeded by the migration)
-- =============================================
INSERT INTO vendors (name, contact_number, email, address) VALUES
  ('Metro Wholesale Center', '08222001122', 'orders@metrowholesale.ph',   'General Santos City, South Cotabato'),
  ('National Bookstore',     '08001234567', 'orders@nationalbookstore.ph', 'Kidapawan City, North Cotabato'),
  ('Puregold Supermarket',   '08223344556', NULL,                          'Kidapawan City, North Cotabato'),
  ('Epson Philippines',      '028781888',   'support@epson.com.ph',        'Makati City, Metro Manila');

-- =============================================
-- 8. ACTIVITY ACTIONS
-- =============================================
INSERT INTO activity_actions (action_name, category) VALUES
  ('Transaction Completed', 'transaction'),
  ('Transaction Voided',    'transaction'),
  ('Inventory Restocked',   'inventory'),
  ('Inventory Adjusted',    'inventory'),
  ('User Login',            'user'),
  ('User Created',          'user'),
  ('Expense Recorded',      'expense'),
  ('Customer Registered',   'customer'),
  ('Print Order Created',   'print_service'),
  ('Product Added',         'product')
ON CONFLICT DO NOTHING;

-- =============================================
-- 5. INVENTORY, STOCK_IN, PRINT ORDERS,
--    TRANSACTIONS, EXPENSES, LOGS
-- =============================================
DO $$
DECLARE
  -- Product IDs
  p_ypad    int8; p_pen     int8; p_tape    int8; p_pan     int8; p_cof     int8;
  p_mug     int8; p_sky     int8; p_noodle  int8; p_scotch  int8; p_stapler int8;
  p_folder  int8; p_water   int8; p_cola    int8; p_alcohol int8; p_notebook int8;
  -- Service supply IDs
  ss_short int8; ss_long int8; ss_a4  int8; ss_photo int8;
  ss_bk    int8; ss_cy   int8; ss_mg  int8; ss_yw    int8;
  -- Stock_in IDs (products)
  si_ypad    int8; si_pen     int8; si_tape    int8; si_pan     int8; si_cof     int8;
  si_mug     int8; si_sky     int8; si_noodle  int8; si_scotch  int8; si_stapler int8;
  si_folder  int8; si_water   int8; si_cola    int8; si_alcohol int8; si_notebook int8;
  -- Inventory item IDs (products)
  inv_ypad    int8; inv_pen     int8; inv_tape    int8; inv_pan     int8; inv_cof     int8;
  inv_mug     int8; inv_sky     int8; inv_noodle  int8; inv_scotch  int8; inv_stapler int8;
  inv_folder  int8; inv_water   int8; inv_cola    int8; inv_alcohol int8; inv_notebook int8;
  -- Supply inventory IDs
  inv_ss_short int8; inv_ss_long int8; inv_ss_a4  int8; inv_ss_photo int8;
  inv_ss_bk    int8; inv_ss_cy   int8; inv_ss_mg  int8; inv_ss_yw    int8;

  -- Service IDs
  svc_bw int8; svc_color int8; svc_photo int8;
  -- Machine IDs
  m_l3110 int8; m_canon int8;
  -- Service type IDs
  st_bw_short int8; st_bw_long int8; st_bw_a4 int8; st_color_a4 int8; st_photo int8;
  -- Print order IDs (po1-po8)
  po1 int8; po2 int8; po3 int8; po4 int8;
  po5 int8; po6 int8; po7 int8; po8 int8;
  -- Profile IDs
  owner_pid   int8; manager_pid int8;
  cashier_pid int8; cashier2_pid int8;
  -- Customer IDs
  cust1 int8; cust2 int8; cust3 int8; cust4 int8; cust5 int8;
  cust6 int8; cust7 int8; cust8 int8; cust9 int8; cust10 int8;
  -- Vendor IDs
  v_printsari int8; v_metro int8; v_nbs int8; v_puregold int8; v_epson int8;
  -- Transaction IDs (30 over 30 days)
  txn1  int8; txn2  int8; txn3  int8; txn4  int8; txn5  int8;
  txn6  int8; txn7  int8; txn8  int8; txn9  int8; txn10 int8;
  txn11 int8; txn12 int8; txn13 int8; txn14 int8; txn15 int8;
  txn16 int8; txn17 int8; txn18 int8; txn19 int8; txn20 int8;
  txn21 int8; txn22 int8; txn23 int8; txn24 int8; txn25 int8;
  txn26 int8; txn27 int8; txn28 int8; txn29 int8; txn30 int8;
  -- Lookup IDs
  status_completed int8;
  pay_cash int8; pay_gcash int8; pay_card int8;
BEGIN
  -- Resolve lookup IDs
  SELECT id INTO status_completed FROM transaction_statuses WHERE status_name = 'completed';
  SELECT id INTO pay_cash  FROM payment_methods WHERE method_name = 'cash';
  SELECT id INTO pay_gcash FROM payment_methods WHERE method_name = 'gcash';
  SELECT id INTO pay_card  FROM payment_methods WHERE method_name = 'card';

  -- Resolve product IDs (by name)
  SELECT id INTO p_ypad     FROM products WHERE name = 'Yellow Pad Short';
  SELECT id INTO p_pen      FROM products WHERE name = 'Ballpen Black';
  SELECT id INTO p_tape     FROM products WHERE name = 'Correction Tape';
  SELECT id INTO p_pan      FROM products WHERE name = 'Pandesal (pack 12)';
  SELECT id INTO p_cof      FROM products WHERE name = 'Coffee 3-in-1 sachet';
  SELECT id INTO p_mug      FROM products WHERE name = 'Mug (ceramic white)';
  SELECT id INTO p_sky      FROM products WHERE name = 'Skyflakes Crackers';
  SELECT id INTO p_noodle   FROM products WHERE name = 'Lucky Me Cup Noodles';
  SELECT id INTO p_scotch   FROM products WHERE name = 'Scotch Tape';
  SELECT id INTO p_stapler  FROM products WHERE name = 'Stapler';
  SELECT id INTO p_folder   FROM products WHERE name = 'Folder Long';
  SELECT id INTO p_water    FROM products WHERE name = 'Mineral Water 500ml';
  SELECT id INTO p_cola     FROM products WHERE name = 'Coca-Cola 500ml';
  SELECT id INTO p_alcohol  FROM products WHERE name = 'Alcohol 70% 250ml';
  SELECT id INTO p_notebook FROM products WHERE name = 'Notebook Spiral (80L)';

  -- Resolve service supply IDs
  SELECT id INTO ss_short FROM service_supplies WHERE name = 'Short Bond Paper (Ream)';
  SELECT id INTO ss_long  FROM service_supplies WHERE name = 'Long Bond Paper (Ream)';
  SELECT id INTO ss_a4    FROM service_supplies WHERE name = 'A4 Bond Paper (Ream)';
  SELECT id INTO ss_photo FROM service_supplies WHERE name = 'Glossy Photo Paper (Pack)';
  SELECT id INTO ss_bk    FROM service_supplies WHERE name = 'Epson Black Ink (T664)';
  SELECT id INTO ss_cy    FROM service_supplies WHERE name = 'Epson Cyan Ink (T664)';
  SELECT id INTO ss_mg    FROM service_supplies WHERE name = 'Epson Magenta Ink (T664)';
  SELECT id INTO ss_yw    FROM service_supplies WHERE name = 'Epson Yellow Ink (T664)';

  -- Resolve profile IDs
  SELECT id INTO owner_pid    FROM profiles WHERE username = 'daniel_owner';
  SELECT id INTO manager_pid  FROM profiles WHERE username = 'jose_manager';
  SELECT id INTO cashier_pid  FROM profiles WHERE username = 'maria_cashier';
  SELECT id INTO cashier2_pid FROM profiles WHERE username = 'pedro_cashier';

  -- Resolve customer IDs
  SELECT id INTO cust1  FROM customers WHERE email = 'juan@email.com';
  SELECT id INTO cust2  FROM customers WHERE email = 'ana.reyes@email.com';
  SELECT id INTO cust3  FROM customers WHERE email = 'pedro.g@email.com';
  SELECT id INTO cust4  FROM customers WHERE email = 'rosa.m@email.com';
  SELECT id INTO cust5  FROM customers WHERE email = 'carlos.t@email.com';
  SELECT id INTO cust6  FROM customers WHERE email = 'nena.v@email.com';
  SELECT id INTO cust7  FROM customers WHERE email = 'rod.b@email.com';
  SELECT id INTO cust8  FROM customers WHERE email = 'carla.f@email.com';
  SELECT id INTO cust9  FROM customers WHERE email = 'manny.t@email.com';
  SELECT id INTO cust10 FROM customers WHERE email = 'grace.o@email.com';

  -- Resolve vendor IDs
  SELECT id INTO v_printsari FROM vendors WHERE name = 'PrintSari Corner';
  SELECT id INTO v_metro     FROM vendors WHERE name = 'Metro Wholesale Center';
  SELECT id INTO v_nbs       FROM vendors WHERE name = 'National Bookstore';
  SELECT id INTO v_puregold  FROM vendors WHERE name = 'Puregold Supermarket';
  SELECT id INTO v_epson     FROM vendors WHERE name = 'Epson Philippines';

  -- =============================================
  -- STOCK_IN — PRODUCTS (initial restock, 30 days ago)
  -- =============================================
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_ypad,     owner_pid,   18.00, 100, NOW() - INTERVAL '30 days') RETURNING id INTO si_ypad;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_pen,      owner_pid,    4.00, 200, NOW() - INTERVAL '30 days') RETURNING id INTO si_pen;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_tape,     owner_pid,   11.00,  60, NOW() - INTERVAL '30 days') RETURNING id INTO si_tape;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_pan,      owner_pid,   25.00, 500, NOW() - INTERVAL '29 days') RETURNING id INTO si_pan;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_cof,      owner_pid,    4.00, 300, NOW() - INTERVAL '29 days') RETURNING id INTO si_cof;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_mug,      owner_pid,   60.00,  12, NOW() - INTERVAL '28 days') RETURNING id INTO si_mug;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_sky,      owner_pid,    8.00,  80, NOW() - INTERVAL '29 days') RETURNING id INTO si_sky;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_noodle,   owner_pid,   14.00, 120, NOW() - INTERVAL '29 days') RETURNING id INTO si_noodle;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_scotch,   owner_pid,    8.00,  50, NOW() - INTERVAL '28 days') RETURNING id INTO si_scotch;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_stapler,  owner_pid,   55.00,  20, NOW() - INTERVAL '28 days') RETURNING id INTO si_stapler;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_folder,   owner_pid,    7.00, 100, NOW() - INTERVAL '28 days') RETURNING id INTO si_folder;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_water,    owner_pid,   12.00, 300, NOW() - INTERVAL '29 days') RETURNING id INTO si_water;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_cola,     owner_pid,   22.00, 200, NOW() - INTERVAL '29 days') RETURNING id INTO si_cola;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_alcohol,  owner_pid,   40.00,  60, NOW() - INTERVAL '28 days') RETURNING id INTO si_alcohol;
  INSERT INTO stock_in (product_id, user_id, purchase_price, quantity_added, stock_in_date)
  VALUES (p_notebook, owner_pid,   30.00, 100, NOW() - INTERVAL '28 days') RETURNING id INTO si_notebook;

  -- =============================================
  -- INVENTORY ITEMS — PRODUCTS
  --   Final stock reflects ~30 days of sales.
  --   Mug: LOW STOCK (3 < reorder 5)
  --   Skyflakes: OUT OF STOCK (0)
  --   Scotch Tape: LOW STOCK (4 < reorder 8)
  --   Folder Long: LOW STOCK (3 < reorder 5)
  -- =============================================
  INSERT INTO inventory_items (product_id, stock, purchase_price, reorder_level, location, last_restocked, stock_in_id) VALUES
    (p_ypad,     45,  35.00, 10, 'Shelf A1', NOW() - INTERVAL '30 days', si_ypad),
    (p_pen,      80,  12.00, 20, 'Shelf A2', NOW() - INTERVAL '30 days', si_pen),
    (p_tape,     22,  22.00, 10, 'Shelf A3', NOW() - INTERVAL '30 days', si_tape),
    (p_pan,     120,  45.00, 30, 'Shelf B1', NOW() - INTERVAL '29 days', si_pan),
    (p_cof,      60,   8.00, 20, 'Shelf B2', NOW() - INTERVAL '29 days', si_cof),
    (p_mug,       3, 120.00,  5, 'Shelf C1', NOW() - INTERVAL '28 days', si_mug),
    (p_sky,       0,  15.00, 15, 'Shelf B3', NOW() - INTERVAL '29 days', si_sky),
    (p_noodle,   35,  25.00, 15, 'Shelf B4', NOW() - INTERVAL '29 days', si_noodle),
    (p_scotch,    4,  15.00,  8, 'Shelf A4', NOW() - INTERVAL '28 days', si_scotch),
    (p_stapler,   7,  95.00,  5, 'Shelf A5', NOW() - INTERVAL '28 days', si_stapler),
    (p_folder,    3,  12.00,  5, 'Shelf A6', NOW() - INTERVAL '28 days', si_folder),
    (p_water,    75,  20.00, 20, 'Shelf D1', NOW() - INTERVAL '29 days', si_water),
    (p_cola,     42,  35.00, 20, 'Shelf D2', NOW() - INTERVAL '29 days', si_cola),
    (p_alcohol,  18,  65.00, 10, 'Shelf C2', NOW() - INTERVAL '28 days', si_alcohol),
    (p_notebook, 28,  55.00, 15, 'Shelf A1', NOW() - INTERVAL '28 days', si_notebook);

  SELECT id INTO inv_ypad     FROM inventory_items WHERE product_id = p_ypad;
  SELECT id INTO inv_pen      FROM inventory_items WHERE product_id = p_pen;
  SELECT id INTO inv_tape     FROM inventory_items WHERE product_id = p_tape;
  SELECT id INTO inv_pan      FROM inventory_items WHERE product_id = p_pan;
  SELECT id INTO inv_cof      FROM inventory_items WHERE product_id = p_cof;
  SELECT id INTO inv_mug      FROM inventory_items WHERE product_id = p_mug;
  SELECT id INTO inv_sky      FROM inventory_items WHERE product_id = p_sky;
  SELECT id INTO inv_noodle   FROM inventory_items WHERE product_id = p_noodle;
  SELECT id INTO inv_scotch   FROM inventory_items WHERE product_id = p_scotch;
  SELECT id INTO inv_stapler  FROM inventory_items WHERE product_id = p_stapler;
  SELECT id INTO inv_folder   FROM inventory_items WHERE product_id = p_folder;
  SELECT id INTO inv_water    FROM inventory_items WHERE product_id = p_water;
  SELECT id INTO inv_cola     FROM inventory_items WHERE product_id = p_cola;
  SELECT id INTO inv_alcohol  FROM inventory_items WHERE product_id = p_alcohol;
  SELECT id INTO inv_notebook FROM inventory_items WHERE product_id = p_notebook;

  -- =============================================
  -- STOCK_IN — SERVICE SUPPLIES
  -- =============================================
  INSERT INTO stock_in (service_supply_id, user_id, purchase_price, quantity_added, stock_in_date) VALUES
    (ss_short, owner_pid, 160.00, 25, NOW() - INTERVAL '28 days'),
    (ss_long,  owner_pid, 180.00, 10, NOW() - INTERVAL '28 days'),
    (ss_a4,    owner_pid, 160.00, 20, NOW() - INTERVAL '28 days'),
    (ss_photo, owner_pid, 350.00, 10, NOW() - INTERVAL '28 days'),
    (ss_bk,    owner_pid, 280.00,  8, NOW() - INTERVAL '28 days'),
    (ss_cy,    owner_pid, 320.00,  5, NOW() - INTERVAL '28 days'),
    (ss_mg,    owner_pid, 320.00,  5, NOW() - INTERVAL '28 days'),
    (ss_yw,    owner_pid, 320.00,  5, NOW() - INTERVAL '28 days');

  -- =============================================
  -- INVENTORY ITEMS — SUPPLIES
  --   Epson Cyan: LOW STOCK (1 bottle remaining)
  -- =============================================
  INSERT INTO inventory_items (service_supply_id, stock, purchase_price, last_restocked) VALUES
    (ss_short, 15, 160.00, NOW() - INTERVAL '28 days'),
    (ss_long,   7, 180.00, NOW() - INTERVAL '28 days'),
    (ss_a4,    10, 160.00, NOW() - INTERVAL '28 days'),
    (ss_photo,  6, 350.00, NOW() - INTERVAL '28 days'),
    (ss_bk,     3, 280.00, NOW() - INTERVAL '28 days'),
    (ss_cy,     1, 320.00, NOW() - INTERVAL '28 days'),
    (ss_mg,     2, 320.00, NOW() - INTERVAL '28 days'),
    (ss_yw,     2, 320.00, NOW() - INTERVAL '28 days');

  SELECT id INTO inv_ss_short FROM inventory_items WHERE service_supply_id = ss_short;
  SELECT id INTO inv_ss_long  FROM inventory_items WHERE service_supply_id = ss_long;
  SELECT id INTO inv_ss_a4    FROM inventory_items WHERE service_supply_id = ss_a4;
  SELECT id INTO inv_ss_photo FROM inventory_items WHERE service_supply_id = ss_photo;
  SELECT id INTO inv_ss_bk    FROM inventory_items WHERE service_supply_id = ss_bk;
  SELECT id INTO inv_ss_cy    FROM inventory_items WHERE service_supply_id = ss_cy;
  SELECT id INTO inv_ss_mg    FROM inventory_items WHERE service_supply_id = ss_mg;
  SELECT id INTO inv_ss_yw    FROM inventory_items WHERE service_supply_id = ss_yw;

  -- =============================================
  -- SERVICES, MACHINES, SERVICE TYPES & COSTS
  -- =============================================
  -- Resolve service IDs
  SELECT id INTO svc_bw    FROM services WHERE name = 'B&W Document Printing';
  SELECT id INTO svc_color FROM services WHERE name = 'Color Document Printing';
  SELECT id INTO svc_photo FROM services WHERE name = 'Photo Printing';

  -- Resolve machine IDs
  SELECT id INTO m_l3110 FROM machines WHERE name = 'Epson L3110 (BW/Color)';
  SELECT id INTO m_canon FROM machines WHERE name = 'Canon PIXMA iP110';

  -- Link machines to their primary service
  UPDATE machines SET service_id = svc_bw    WHERE id = m_l3110;
  UPDATE machines SET service_id = svc_photo WHERE id = m_canon;

  -- Insert service types
  INSERT INTO service_types (service_id, service_supply_id, machine_id, name, paper_size, color_mode)
  VALUES (svc_bw,    ss_short, m_l3110, 'B&W Short',  'short', 'bw')
  RETURNING id INTO st_bw_short;

  INSERT INTO service_types (service_id, service_supply_id, machine_id, name, paper_size, color_mode)
  VALUES (svc_bw,    ss_long,  m_l3110, 'B&W Long',   'long',  'bw')
  RETURNING id INTO st_bw_long;

  INSERT INTO service_types (service_id, service_supply_id, machine_id, name, paper_size, color_mode)
  VALUES (svc_bw,    ss_a4,    m_l3110, 'B&W A4',     'a4',    'bw')
  RETURNING id INTO st_bw_a4;

  INSERT INTO service_types (service_id, service_supply_id, machine_id, name, paper_size, color_mode)
  VALUES (svc_color, ss_a4,    m_l3110, 'Color A4',   'a4',    'color')
  RETURNING id INTO st_color_a4;

  INSERT INTO service_types (service_id, service_supply_id, machine_id, name, paper_size, color_mode)
  VALUES (svc_photo, ss_photo, m_canon, 'Photo 4R',   'a4',    'color')
  RETURNING id INTO st_photo;

  -- Insert service type costs (per-page rates)
  --   B&W Short:  supply=0.33, ink=0.00, elec=0.00, labor=0.00, total=0.33, selling=3.00
  --   B&W Long:   supply=0.38, ink=0.00, elec=0.00, labor=0.00, total=0.38, selling=4.00
  --   B&W A4:     supply=0.33, ink=0.00, elec=0.00, labor=0.00, total=0.33, selling=3.00
  --   Color A4:   supply=0.33, ink=1.20, elec=0.10, labor=0.12, total=1.75, selling=10.00
  --   Photo 4R:   supply=4.20, ink=0.00, elec=0.00, labor=0.00, total=4.20, selling=20.00
  INSERT INTO service_type_costs (service_type_id, service_supply_cost, ink_cost, electricity_cost, labor_cost, service_selling_price)
  VALUES
    (st_bw_short,  0.33, 0.00, 0.00, 0.00,  3.00),
    (st_bw_long,   0.38, 0.00, 0.00, 0.00,  4.00),
    (st_bw_a4,     0.33, 0.00, 0.00, 0.00,  3.00),
    (st_color_a4,  0.33, 1.20, 0.10, 0.12, 10.00),
    (st_photo,     4.20, 0.00, 0.00, 0.00, 20.00);

  -- =============================================
  -- PRINT ORDERS (8 reusable templates)
  --   service_type_id → the service type used
  --   po1: B&W Short 30p  = ₱90,  cost ₱9.90
  --   po2: B&W A4    50p  = ₱150, cost ₱16.50
  --   po3: B&W A4   100p  = ₱300, cost ₱33.00
  --   po4: Color A4  10p  = ₱100, cost ₱17.50
  --   po5: Color A4  20p  = ₱200, cost ₱35.00
  --   po6: Photo 4R   5p  = ₱100, cost ₱21.00
  --   po7: Photo 4R  10p  = ₱200, cost ₱42.00
  --   po8: B&W Long  20p  = ₱80,  cost ₱7.60
  -- =============================================
  INSERT INTO print_orders (service_type_id, quantity, total_price, total_cost, profit_margin)
  VALUES (st_bw_short,  30,  90.00,  9.90,  80.10) RETURNING id INTO po1;
  INSERT INTO print_orders (service_type_id, quantity, total_price, total_cost, profit_margin)
  VALUES (st_bw_a4,     50, 150.00, 16.50, 133.50) RETURNING id INTO po2;
  INSERT INTO print_orders (service_type_id, quantity, total_price, total_cost, profit_margin)
  VALUES (st_bw_a4,    100, 300.00, 33.00, 267.00) RETURNING id INTO po3;
  INSERT INTO print_orders (service_type_id, quantity, total_price, total_cost, profit_margin)
  VALUES (st_color_a4,  10, 100.00, 17.50,  82.50) RETURNING id INTO po4;
  INSERT INTO print_orders (service_type_id, quantity, total_price, total_cost, profit_margin)
  VALUES (st_color_a4,  20, 200.00, 35.00, 165.00) RETURNING id INTO po5;
  INSERT INTO print_orders (service_type_id, quantity, total_price, total_cost, profit_margin)
  VALUES (st_photo,      5, 100.00, 21.00,  79.00) RETURNING id INTO po6;
  INSERT INTO print_orders (service_type_id, quantity, total_price, total_cost, profit_margin)
  VALUES (st_photo,     10, 200.00, 42.00, 158.00) RETURNING id INTO po7;
  INSERT INTO print_orders (service_type_id, quantity, total_price, total_cost, profit_margin)
  VALUES (st_bw_long,   20,  80.00,  7.60,  72.40) RETURNING id INTO po8;

  -- =============================================
  -- TRANSACTIONS (30 over 30 days)
  --   Revenue legend: store_revenue + printing_revenue = total
  --   Bundles used:
  --     Medium:  pan×2(90)+cof×5(40)+water×3(60)          = ₱190, cost ₱106
  --     Large:   pan×4(180)+cof×8(64)+water×5(100)        = ₱344, cost ₱192
  --     Small:   pan×1(45)+cof×3(24)+pen×2(24)            = ₱93,  cost ₱45
  --     Station: ypad×2(70)+pen×5(60)+tape×2(44)+nb×1(55) = ₱229, cost ₱124
  -- =============================================

  -- D28: Medium store ₱190
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'28 days','YYYYMMDD')||'-001', 190.00, 190.00, NOW()-INTERVAL'28 days 9 hours', status_completed, pay_cash,  cashier_pid,  cust1,  190.00,   0.00, 106.00,  84.00) RETURNING id INTO txn1;

  -- D27: Print po3 (B&W A4 100p) ₱300
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'27 days','YYYYMMDD')||'-001', 300.00, 300.00, NOW()-INTERVAL'27 days 10 hours', status_completed, pay_gcash, cashier_pid,  cust2,    0.00, 300.00,  33.00, 267.00) RETURNING id INTO txn2;

  -- D26: Small store + po1 (B&W Short 30p) ₱183
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit, notes)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'26 days','YYYYMMDD')||'-001', 183.00, 183.00, NOW()-INTERVAL'26 days 2 hours',  status_completed, pay_cash,  cashier2_pid, NULL,    93.00,  90.00,  54.90, 128.10, 'Walk-in') RETURNING id INTO txn3;

  -- D25: Large store ₱344
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'25 days','YYYYMMDD')||'-001', 344.00, 344.00, NOW()-INTERVAL'25 days 11 hours', status_completed, pay_cash,  cashier_pid,  cust3,  344.00,   0.00, 192.00, 152.00) RETURNING id INTO txn4;

  -- D24: Print po5 (Colored A4 20p) ₱200
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit, notes)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'24 days','YYYYMMDD')||'-001', 200.00, 200.00, NOW()-INTERVAL'24 days 3 hours',  status_completed, pay_gcash, cashier_pid,  cust4,    0.00, 200.00,  35.00, 165.00, 'Color print job') RETURNING id INTO txn5;

  -- D23: Medium store ₱190
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'23 days','YYYYMMDD')||'-001', 190.00, 190.00, NOW()-INTERVAL'23 days 8 hours',  status_completed, pay_cash,  cashier2_pid, NULL,   190.00,   0.00, 106.00,  84.00) RETURNING id INTO txn6;

  -- D22: Stationery + po4 (Colored 10p) ₱329
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'22 days','YYYYMMDD')||'-001', 329.00, 329.00, NOW()-INTERVAL'22 days 4 hours',  status_completed, pay_card,  cashier_pid,  cust5,  229.00, 100.00, 141.50, 187.50) RETURNING id INTO txn7;

  -- D21: Print po3 ₱300
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit, notes)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'21 days','YYYYMMDD')||'-001', 300.00, 300.00, NOW()-INTERVAL'21 days 9 hours',  status_completed, pay_gcash, cashier_pid,  cust6,    0.00, 300.00,  33.00, 267.00, 'Thesis printing') RETURNING id INTO txn8;

  -- D20: Large store ₱344
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'20 days','YYYYMMDD')||'-001', 344.00, 344.00, NOW()-INTERVAL'20 days 10 hours', status_completed, pay_cash,  cashier2_pid, cust1,  344.00,   0.00, 192.00, 152.00) RETURNING id INTO txn9;

  -- D19: Stationery ₱229
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'19 days','YYYYMMDD')||'-001', 229.00, 229.00, NOW()-INTERVAL'19 days 4 hours',  status_completed, pay_cash,  cashier_pid,  cust7,  229.00,   0.00, 124.00, 105.00) RETURNING id INTO txn10;

  -- D18: Print po7 (Photo 4R 10p) ₱200
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit, notes)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'18 days','YYYYMMDD')||'-001', 200.00, 200.00, NOW()-INTERVAL'18 days 2 hours',  status_completed, pay_gcash, cashier2_pid, cust2,    0.00, 200.00,  42.00, 158.00, 'Photo prints') RETURNING id INTO txn11;

  -- D17: Medium store + po1 (B&W Short 30p) ₱280
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'17 days','YYYYMMDD')||'-001', 280.00, 280.00, NOW()-INTERVAL'17 days 11 hours', status_completed, pay_cash,  cashier_pid,  cust8,  190.00,  90.00, 115.90, 164.10) RETURNING id INTO txn12;

  -- D16: Print po4 (Colored 10p) ₱100
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'16 days','YYYYMMDD')||'-001', 100.00, 100.00, NOW()-INTERVAL'16 days 3 hours',  status_completed, pay_gcash, cashier2_pid, cust9,    0.00, 100.00,  17.50,  82.50) RETURNING id INTO txn13;

  -- D15: Large store ₱344
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'15 days','YYYYMMDD')||'-001', 344.00, 344.00, NOW()-INTERVAL'15 days 9 hours',  status_completed, pay_cash,  cashier_pid,  cust10, 344.00,   0.00, 192.00, 152.00) RETURNING id INTO txn14;

  -- D14: Print po3 + Medium store ₱490
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit, notes)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'14 days','YYYYMMDD')||'-001', 490.00, 490.00, NOW()-INTERVAL'14 days 10 hours', status_completed, pay_gcash, cashier_pid,  cust2,  190.00, 300.00, 139.00, 351.00, 'Research paper printing') RETURNING id INTO txn15;

  -- D13: Medium store ₱190
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'13 days','YYYYMMDD')||'-001', 190.00, 190.00, NOW()-INTERVAL'13 days 8 hours',  status_completed, pay_cash,  cashier2_pid, NULL,   190.00,   0.00, 106.00,  84.00) RETURNING id INTO txn16;

  -- D12: Print po6 (Photo 4R 5p) ₱100
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'12 days','YYYYMMDD')||'-001', 100.00, 100.00, NOW()-INTERVAL'12 days 3 hours',  status_completed, pay_gcash, cashier_pid,  cust3,    0.00, 100.00,  21.00,  79.00) RETURNING id INTO txn17;

  -- D11: Small store ₱93
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'11 days','YYYYMMDD')||'-001',  93.00,  93.00, NOW()-INTERVAL'11 days 7 hours',  status_completed, pay_cash,  cashier2_pid, cust4,   93.00,   0.00,  45.00,  48.00) RETURNING id INTO txn18;

  -- D10: Large store + po2 (B&W A4 50p) ₱494
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit, notes)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'10 days','YYYYMMDD')||'-001', 494.00, 494.00, NOW()-INTERVAL'10 days 11 hours', status_completed, pay_card,  cashier_pid,  cust5,  344.00, 150.00, 208.50, 285.50, 'Bulk purchase + printing') RETURNING id INTO txn19;

  -- D9: Print po5 (Colored 20p) ₱200
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'9 days','YYYYMMDD')||'-001',  200.00, 200.00, NOW()-INTERVAL'9 days 2 hours',   status_completed, pay_gcash, cashier2_pid, cust6,    0.00, 200.00,  35.00, 165.00) RETURNING id INTO txn20;

  -- D8: Medium store ₱190
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'8 days','YYYYMMDD')||'-001',  190.00, 190.00, NOW()-INTERVAL'8 days 9 hours',   status_completed, pay_cash,  cashier_pid,  cust7,  190.00,   0.00, 106.00,  84.00) RETURNING id INTO txn21;

  -- D7: Print po3 (B&W A4 100p) ₱300
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit, notes)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'7 days','YYYYMMDD')||'-001',  300.00, 300.00, NOW()-INTERVAL'7 days 10 hours',  status_completed, pay_gcash, cashier_pid,  cust8,    0.00, 300.00,  33.00, 267.00, 'Thesis chapter printing') RETURNING id INTO txn22;

  -- D6: Stationery ₱229
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'6 days','YYYYMMDD')||'-001',  229.00, 229.00, NOW()-INTERVAL'6 days 4 hours',   status_completed, pay_cash,  cashier2_pid, cust9,  229.00,   0.00, 124.00, 105.00) RETURNING id INTO txn23;

  -- D5: Medium store + po4 (Colored 10p) ₱290
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'5 days','YYYYMMDD')||'-001',  290.00, 290.00, NOW()-INTERVAL'5 days 11 hours',  status_completed, pay_gcash, cashier_pid,  cust10, 190.00, 100.00, 123.50, 166.50) RETURNING id INTO txn24;

  -- D4: Large store ₱344
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'4 days','YYYYMMDD')||'-001',  344.00, 344.00, NOW()-INTERVAL'4 days 8 hours',   status_completed, pay_cash,  cashier2_pid, cust1,  344.00,   0.00, 192.00, 152.00) RETURNING id INTO txn25;

  -- D3: Print po7 (Photo 4R 10p) ₱200
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'3 days','YYYYMMDD')||'-001',  200.00, 200.00, NOW()-INTERVAL'3 days 3 hours',   status_completed, pay_gcash, cashier_pid,  cust2,    0.00, 200.00,  42.00, 158.00) RETURNING id INTO txn26;

  -- D2: Small store + po1 (B&W Short 30p) ₱183
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'2 days','YYYYMMDD')||'-001',  183.00, 183.00, NOW()-INTERVAL'2 days 10 hours',  status_completed, pay_cash,  cashier2_pid, cust3,   93.00,  90.00,  54.90, 128.10) RETURNING id INTO txn27;

  -- D1: Medium store ₱190
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW()-INTERVAL'1 day','YYYYMMDD')||'-001',   190.00, 190.00, NOW()-INTERVAL'1 day 9 hours',    status_completed, pay_cash,  cashier_pid,  cust4,  190.00,   0.00, 106.00,  84.00) RETURNING id INTO txn28;

  -- Today: Print po3 ₱300
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit, notes)
  VALUES ('TXN-'||TO_CHAR(NOW(),'YYYYMMDD')||'-001',                   300.00, 300.00, NOW()-INTERVAL'3 hours',           status_completed, pay_gcash, cashier_pid,  cust5,    0.00, 300.00,  33.00, 267.00, 'Final thesis print') RETURNING id INTO txn29;

  -- Today: Medium store ₱190
  INSERT INTO transactions (transaction_number, subtotal, total, date, status_id, payment_method_id, cashier_id, customer_id, store_revenue, printing_revenue, total_cost, gross_profit)
  VALUES ('TXN-'||TO_CHAR(NOW(),'YYYYMMDD')||'-002',                   190.00, 190.00, NOW()-INTERVAL'1 hour',            status_completed, pay_cash,  cashier2_pid, NULL,   190.00,   0.00, 106.00,  84.00) RETURNING id INTO txn30;

  -- =============================================
  -- TRANSACTION ITEMS
  -- =============================================

  -- txn1 (D28): Medium store — pan×2 + cof×5 + water×3 = ₱190
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn1, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn1, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn1, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);

  -- txn2 (D27): Print po3 — B&W A4 100 pages = ₱300
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn2, 'Print B&W A4 - 100 pages', 1, 300.00, 300.00, 2, po3, 33.00);

  -- txn3 (D26): Small store + po1
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn3, inv_pan, p_pan, 'Pandesal (pack 12)',   1, 45.00, 45.00, 1, 25.00),
    (txn3, inv_cof, p_cof, 'Coffee 3-in-1 sachet', 3,  8.00, 24.00, 1, 12.00),
    (txn3, inv_pen, p_pen, 'Ballpen Black',         2, 12.00, 24.00, 1,  8.00);
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn3, 'Photocopy B&W Short - 30 pages', 1, 90.00, 90.00, 2, po1, 9.90);

  -- txn4 (D25): Large store — pan×4 + cof×8 + water×5 = ₱344
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn4, inv_pan,   p_pan,   'Pandesal (pack 12)',   4, 45.00, 180.00, 1, 100.00),
    (txn4, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 8,  8.00,  64.00, 1,  32.00),
    (txn4, inv_water, p_water, 'Mineral Water 500ml',  5, 20.00, 100.00, 1,  60.00);

  -- txn5 (D24): Print po5 — Colored A4 20 pages = ₱200
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn5, 'Print Colored A4 - 20 pages', 1, 200.00, 200.00, 2, po5, 35.00);

  -- txn6 (D23): Medium store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn6, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn6, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn6, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);

  -- txn7 (D22): Stationery + po4
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn7, inv_ypad,     p_ypad,    'Yellow Pad Short',      2, 35.00,  70.00, 1, 36.00),
    (txn7, inv_pen,      p_pen,     'Ballpen Black',          5, 12.00,  60.00, 1, 20.00),
    (txn7, inv_tape,     p_tape,    'Correction Tape',        2, 22.00,  44.00, 1, 22.00),
    (txn7, inv_notebook, p_notebook,'Notebook Spiral (80L)',  1, 55.00,  55.00, 1, 30.00);
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn7, 'Print Colored A4 - 10 pages', 1, 100.00, 100.00, 2, po4, 17.50);

  -- txn8 (D21): Print po3
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn8, 'Print B&W A4 - 100 pages', 1, 300.00, 300.00, 2, po3, 33.00);

  -- txn9 (D20): Large store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn9, inv_pan,   p_pan,   'Pandesal (pack 12)',   4, 45.00, 180.00, 1, 100.00),
    (txn9, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 8,  8.00,  64.00, 1,  32.00),
    (txn9, inv_water, p_water, 'Mineral Water 500ml',  5, 20.00, 100.00, 1,  60.00);

  -- txn10 (D19): Stationery
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn10, inv_ypad,     p_ypad,    'Yellow Pad Short',      2, 35.00,  70.00, 1, 36.00),
    (txn10, inv_pen,      p_pen,     'Ballpen Black',          5, 12.00,  60.00, 1, 20.00),
    (txn10, inv_tape,     p_tape,    'Correction Tape',        2, 22.00,  44.00, 1, 22.00),
    (txn10, inv_notebook, p_notebook,'Notebook Spiral (80L)',  1, 55.00,  55.00, 1, 30.00);

  -- txn11 (D18): Print po7
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn11, 'Print Photo 4R - 10 photos', 1, 200.00, 200.00, 2, po7, 42.00);

  -- txn12 (D17): Medium store + po1
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn12, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn12, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn12, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn12, 'Photocopy B&W Short - 30 pages', 1, 90.00, 90.00, 2, po1, 9.90);

  -- txn13 (D16): Print po4
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn13, 'Print Colored A4 - 10 pages', 1, 100.00, 100.00, 2, po4, 17.50);

  -- txn14 (D15): Large store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn14, inv_pan,   p_pan,   'Pandesal (pack 12)',   4, 45.00, 180.00, 1, 100.00),
    (txn14, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 8,  8.00,  64.00, 1,  32.00),
    (txn14, inv_water, p_water, 'Mineral Water 500ml',  5, 20.00, 100.00, 1,  60.00);

  -- txn15 (D14): Print po3 + Medium store
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn15, 'Print B&W A4 - 100 pages', 1, 300.00, 300.00, 2, po3, 33.00);
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn15, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn15, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn15, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);

  -- txn16 (D13): Medium store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn16, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn16, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn16, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);

  -- txn17 (D12): Print po6
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn17, 'Print Photo 4R - 5 photos', 1, 100.00, 100.00, 2, po6, 21.00);

  -- txn18 (D11): Small store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn18, inv_pan, p_pan, 'Pandesal (pack 12)',   1, 45.00, 45.00, 1, 25.00),
    (txn18, inv_cof, p_cof, 'Coffee 3-in-1 sachet', 3,  8.00, 24.00, 1, 12.00),
    (txn18, inv_pen, p_pen, 'Ballpen Black',         2, 12.00, 24.00, 1,  8.00);

  -- txn19 (D10): Large store + po2
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn19, inv_pan,   p_pan,   'Pandesal (pack 12)',   4, 45.00, 180.00, 1, 100.00),
    (txn19, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 8,  8.00,  64.00, 1,  32.00),
    (txn19, inv_water, p_water, 'Mineral Water 500ml',  5, 20.00, 100.00, 1,  60.00);
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn19, 'Print B&W A4 - 50 pages', 1, 150.00, 150.00, 2, po2, 16.50);

  -- txn20 (D9): Print po5
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn20, 'Print Colored A4 - 20 pages', 1, 200.00, 200.00, 2, po5, 35.00);

  -- txn21 (D8): Medium store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn21, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn21, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn21, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);

  -- txn22 (D7): Print po3
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn22, 'Print B&W A4 - 100 pages', 1, 300.00, 300.00, 2, po3, 33.00);

  -- txn23 (D6): Stationery
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn23, inv_ypad,     p_ypad,    'Yellow Pad Short',      2, 35.00,  70.00, 1, 36.00),
    (txn23, inv_pen,      p_pen,     'Ballpen Black',          5, 12.00,  60.00, 1, 20.00),
    (txn23, inv_tape,     p_tape,    'Correction Tape',        2, 22.00,  44.00, 1, 22.00),
    (txn23, inv_notebook, p_notebook,'Notebook Spiral (80L)',  1, 55.00,  55.00, 1, 30.00);

  -- txn24 (D5): Medium store + po4
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn24, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn24, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn24, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn24, 'Print Colored A4 - 10 pages', 1, 100.00, 100.00, 2, po4, 17.50);

  -- txn25 (D4): Large store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn25, inv_pan,   p_pan,   'Pandesal (pack 12)',   4, 45.00, 180.00, 1, 100.00),
    (txn25, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 8,  8.00,  64.00, 1,  32.00),
    (txn25, inv_water, p_water, 'Mineral Water 500ml',  5, 20.00, 100.00, 1,  60.00);

  -- txn26 (D3): Print po7
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn26, 'Print Photo 4R - 10 photos', 1, 200.00, 200.00, 2, po7, 42.00);

  -- txn27 (D2): Small store + po1
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn27, inv_pan, p_pan, 'Pandesal (pack 12)',   1, 45.00, 45.00, 1, 25.00),
    (txn27, inv_cof, p_cof, 'Coffee 3-in-1 sachet', 3,  8.00, 24.00, 1, 12.00),
    (txn27, inv_pen, p_pen, 'Ballpen Black',         2, 12.00, 24.00, 1,  8.00);
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn27, 'Photocopy B&W Short - 30 pages', 1, 90.00, 90.00, 2, po1, 9.90);

  -- txn28 (D1): Medium store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn28, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn28, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn28, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);

  -- txn29 (Today): Print po3
  INSERT INTO transaction_items (transaction_id, product_name, quantity, unit_price, subtotal, category_id, print_order_id, item_cost) VALUES
    (txn29, 'Print B&W A4 - 100 pages', 1, 300.00, 300.00, 2, po3, 33.00);

  -- txn30 (Today): Medium store
  INSERT INTO transaction_items (transaction_id, inventory_id, product_id, product_name, quantity, unit_price, subtotal, category_id, item_cost) VALUES
    (txn30, inv_pan,   p_pan,   'Pandesal (pack 12)',   2, 45.00,  90.00, 1, 50.00),
    (txn30, inv_cof,   p_cof,   'Coffee 3-in-1 sachet', 5,  8.00,  40.00, 1, 20.00),
    (txn30, inv_water, p_water, 'Mineral Water 500ml',  3, 20.00,  60.00, 1, 36.00);

  -- =============================================
  -- STOCK_OUT (sample records)
  -- =============================================
  INSERT INTO stock_out (transaction_id, product_id, inventory_item_id, user_id, quantity_removed, stock_out_type, stock_out_date) VALUES
    (txn1,  p_pan,   inv_pan,   cashier_pid,  2, 'sale',       NOW()-INTERVAL'28 days 9 hours'),
    (txn4,  p_pan,   inv_pan,   cashier_pid,  4, 'sale',       NOW()-INTERVAL'25 days 11 hours'),
    (txn4,  p_water, inv_water, cashier_pid,  5, 'sale',       NOW()-INTERVAL'25 days 11 hours'),
    (txn9,  p_cof,   inv_cof,   cashier2_pid, 8, 'sale',       NOW()-INTERVAL'20 days 10 hours'),
    (txn14, p_pan,   inv_pan,   cashier_pid,  4, 'sale',       NOW()-INTERVAL'15 days 9 hours'),
    (txn19, p_water, inv_water, cashier_pid,  5, 'sale',       NOW()-INTERVAL'10 days 11 hours'),
    -- Manual adjustments (spoilage/damage)
    (NULL,  p_sky,   inv_sky,   owner_pid,   15, 'adjustment', NOW()-INTERVAL'10 days'),
    (NULL,  p_pan,   inv_pan,   owner_pid,    5, 'adjustment', NOW()-INTERVAL'5 days');

  -- =============================================
  -- EXPENSES (17 manual + 4 auto-generated print)
  --   Distributed over 30 days with vendor_id FK
  -- =============================================

  -- D28 — Monthly salaries & rent
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Monthly salaries — April 2026',       25000.00, (SELECT id FROM expense_categories WHERE category_name = 'salaries'),       NOW()-INTERVAL'28 days', 1, v_printsari, pay_cash,  'April payroll'),
    ('Shop rent — April 2026',               8000.00, (SELECT id FROM expense_categories WHERE category_name = 'rent'),           NOW()-INTERVAL'28 days', 1, NULL,        pay_cash,  'Paid to landlord');

  -- D25 — Store restock
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Store restock — food & beverages',     4500.00, (SELECT id FROM expense_categories WHERE category_name = 'store_inventory'), NOW()-INTERVAL'25 days', 1, v_metro,    pay_cash,  'Pan, coffee, noodles, water, cola'),
    ('Store restock — stationery items',     3200.00, (SELECT id FROM expense_categories WHERE category_name = 'store_inventory'), NOW()-INTERVAL'25 days', 1, v_nbs,      pay_cash,  'Pads, pens, tape, folders, notebooks');

  -- D22 — Printer paper restock
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Printer paper — A4 bond (10 reams)',   1600.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_paper'),  NOW()-INTERVAL'22 days', 1, v_nbs,      pay_gcash, '10 reams A4 bond paper'),
    ('Printer paper — short bond (8 reams)', 1280.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_paper'),  NOW()-INTERVAL'22 days', 1, v_nbs,      pay_gcash, '8 reams short bond paper');

  -- D21 — Utilities
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Electricity bill — March billing',     2800.00, (SELECT id FROM expense_categories WHERE category_name = 'utilities'),       NOW()-INTERVAL'21 days', 1, NULL,        pay_cash,  'March 2026 electric bill'),
    ('Internet subscription — monthly',      1500.00, (SELECT id FROM expense_categories WHERE category_name = 'utilities'),       NOW()-INTERVAL'21 days', 1, v_printsari, pay_gcash, 'Fiber internet monthly');

  -- D19 — Printer ink restock
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Epson black ink T664 — 4 bottles',     1120.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_ink'),    NOW()-INTERVAL'19 days', 1, v_epson,     pay_gcash, '4 × ₱280'),
    ('Epson color inks T664 (C/M/Y) — set',  2880.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_ink'),    NOW()-INTERVAL'19 days', 1, v_epson,     pay_gcash, '3 cyan + 3 magenta + 3 yellow = 9 × ₱320');

  -- D15 — Cleaning supplies
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id) VALUES
    ('Cleaning supplies — mop, soap, rags',    600.00, (SELECT id FROM expense_categories WHERE category_name = 'supplies'),       NOW()-INTERVAL'15 days', 1, v_puregold,  pay_cash);

  -- D11 — Store restock (mid-month)
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Store restock — food mid-month',        3800.00, (SELECT id FROM expense_categories WHERE category_name = 'store_inventory'), NOW()-INTERVAL'11 days', 1, v_metro,     pay_cash,  'Pandesal, coffee, noodles top-up');

  -- D8 — Paper restock
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Printer paper — A4 bond (10 reams)',    1600.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_paper'),  NOW()-INTERVAL'8 days',  1, v_nbs,       pay_gcash, 'Mid-month A4 restock');

  -- D7 — Electricity
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Electricity bill — April billing',      2500.00, (SELECT id FROM expense_categories WHERE category_name = 'utilities'),       NOW()-INTERVAL'7 days',  1, NULL,        pay_cash,  'April 2026 electric bill');

  -- D5 — Beverages restock & cleaning
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Store restock — beverages & snacks',    2200.00, (SELECT id FROM expense_categories WHERE category_name = 'store_inventory'), NOW()-INTERVAL'5 days',  1, v_puregold,  pay_cash,  'Water, cola, skyflakes, alcohol'),
    ('Cleaning & hygiene supplies',            450.00, (SELECT id FROM expense_categories WHERE category_name = 'supplies'),        NOW()-INTERVAL'5 days',  1, v_puregold,  pay_cash,  NULL);

  -- D1 — Internet
  INSERT INTO expenses (description, amount, category_id, date, source_id, vendor_id, payment_method_id, notes) VALUES
    ('Internet subscription — monthly',       1500.00, (SELECT id FROM expense_categories WHERE category_name = 'utilities'),       NOW()-INTERVAL'1 day',   1, v_printsari, pay_gcash, 'May fiber internet');

  -- Auto-generated print expenses (source_id = 2)
  INSERT INTO expenses (description, amount, category_id, date, source_id, linked_transaction_id) VALUES
    ('Ink cost — Print B&W A4 100p',   20.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_ink'),         NOW()-INTERVAL'27 days 10 hours', 2, txn2),
    ('Paper cost — Print B&W A4 100p', 10.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_paper'),       NOW()-INTERVAL'27 days 10 hours', 2, txn2),
    ('Elec cost — Print B&W A4 100p',   2.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_electricity'), NOW()-INTERVAL'27 days 10 hours', 2, txn2),
    ('Labor cost — Print B&W A4 100p',  1.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_maintenance'), NOW()-INTERVAL'27 days 10 hours', 2, txn2);

  INSERT INTO expenses (description, amount, category_id, date, source_id, linked_transaction_id) VALUES
    ('Ink cost — Print Photo 4R 10p',   30.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_ink'),         NOW()-INTERVAL'18 days 2 hours', 2, txn11),
    ('Paper cost — Print Photo 4R 10p', 10.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_paper'),       NOW()-INTERVAL'18 days 2 hours', 2, txn11),
    ('Elec cost — Print Photo 4R 10p',   1.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_electricity'), NOW()-INTERVAL'18 days 2 hours', 2, txn11),
    ('Labor cost — Print Photo 4R 10p',  1.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_maintenance'), NOW()-INTERVAL'18 days 2 hours', 2, txn11);

  INSERT INTO expenses (description, amount, category_id, date, source_id, linked_transaction_id) VALUES
    ('Ink cost — Print B&W A4 100p',   20.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_ink'),         NOW()-INTERVAL'14 days 10 hours', 2, txn15),
    ('Paper cost — Print B&W A4 100p', 10.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_paper'),       NOW()-INTERVAL'14 days 10 hours', 2, txn15),
    ('Elec cost — Print B&W A4 100p',   2.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_electricity'), NOW()-INTERVAL'14 days 10 hours', 2, txn15),
    ('Labor cost — Print B&W A4 100p',  1.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_maintenance'), NOW()-INTERVAL'14 days 10 hours', 2, txn15);

  INSERT INTO expenses (description, amount, category_id, date, source_id, linked_transaction_id) VALUES
    ('Ink cost — Print B&W A4 100p',   20.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_ink'),         NOW()-INTERVAL'3 hours', 2, txn29),
    ('Paper cost — Print B&W A4 100p', 10.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_paper'),       NOW()-INTERVAL'3 hours', 2, txn29),
    ('Elec cost — Print B&W A4 100p',   2.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_electricity'), NOW()-INTERVAL'3 hours', 2, txn29),
    ('Labor cost — Print B&W A4 100p',  1.00, (SELECT id FROM expense_categories WHERE category_name = 'printing_maintenance'), NOW()-INTERVAL'3 hours', 2, txn29);

  -- =============================================
  -- LOGIN HISTORY
  -- =============================================
  INSERT INTO login_history (profile_id, username, login_time, logout_time) VALUES
    (owner_pid,    'daniel_owner',  NOW()-INTERVAL'28 days 7 hours', NOW()-INTERVAL'28 days 5 hours'),
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'27 days 8 hours', NOW()-INTERVAL'27 days 4 hours'),
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'25 days 8 hours', NOW()-INTERVAL'25 days 4 hours'),
    (manager_pid,  'jose_manager',  NOW()-INTERVAL'24 days 9 hours', NOW()-INTERVAL'24 days 6 hours'),
    (cashier2_pid, 'pedro_cashier', NOW()-INTERVAL'23 days 8 hours', NOW()-INTERVAL'23 days 4 hours'),
    (owner_pid,    'daniel_owner',  NOW()-INTERVAL'21 days 7 hours', NOW()-INTERVAL'21 days 5 hours'),
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'20 days 8 hours', NOW()-INTERVAL'20 days 4 hours'),
    (manager_pid,  'jose_manager',  NOW()-INTERVAL'18 days 9 hours', NOW()-INTERVAL'18 days 6 hours'),
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'17 days 8 hours', NOW()-INTERVAL'17 days 4 hours'),
    (cashier2_pid, 'pedro_cashier', NOW()-INTERVAL'15 days 8 hours', NOW()-INTERVAL'15 days 3 hours'),
    (owner_pid,    'daniel_owner',  NOW()-INTERVAL'14 days 9 hours', NOW()-INTERVAL'14 days 7 hours'),
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'13 days 8 hours', NOW()-INTERVAL'13 days 4 hours'),
    (manager_pid,  'jose_manager',  NOW()-INTERVAL'10 days 9 hours', NOW()-INTERVAL'10 days 6 hours'),
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'8 days 8 hours',  NOW()-INTERVAL'8 days 4 hours'),
    (cashier2_pid, 'pedro_cashier', NOW()-INTERVAL'6 days 8 hours',  NOW()-INTERVAL'6 days 3 hours'),
    (owner_pid,    'daniel_owner',  NOW()-INTERVAL'5 days 9 hours',  NOW()-INTERVAL'5 days 7 hours'),
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'4 days 8 hours',  NOW()-INTERVAL'4 days 4 hours'),
    (manager_pid,  'jose_manager',  NOW()-INTERVAL'3 days 9 hours',  NOW()-INTERVAL'3 days 6 hours'),
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'2 days 8 hours',  NOW()-INTERVAL'2 days 4 hours'),
    (cashier2_pid, 'pedro_cashier', NOW()-INTERVAL'1 day 8 hours',   NOW()-INTERVAL'1 day 3 hours'),
    (owner_pid,    'daniel_owner',  NOW()-INTERVAL'1 day 9 hours',   NOW()-INTERVAL'1 day 7 hours'),
    -- Today: cashier still logged in
    (cashier_pid,  'maria_cashier', NOW()-INTERVAL'4 hours', NULL),
    (cashier2_pid, 'pedro_cashier', NOW()-INTERVAL'3 hours', NULL);

  -- =============================================
  -- ACTIVITY LOGS
  -- =============================================
  INSERT INTO activity_logs (action_id, description, timestamp, performed_by, performed_by_id) VALUES
    ((SELECT id FROM activity_actions WHERE action_name = 'Transaction Completed' LIMIT 1), 'Completed sale — ₱190.00',                      NOW()-INTERVAL'1 hour',             'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Transaction Completed' LIMIT 1), 'Completed print job — ₱300.00 (B&W A4 100p)',   NOW()-INTERVAL'3 hours',            'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Print Order Created'   LIMIT 1), 'Print order: B&W A4 100 pages',                  NOW()-INTERVAL'3 hours 2 minutes',  'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Transaction Completed' LIMIT 1), 'Completed sale — ₱190.00',                      NOW()-INTERVAL'1 day 9 hours',      'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Expense Recorded'      LIMIT 1), 'Recorded expense: Internet — ₱1,500.00',         NOW()-INTERVAL'1 day',              'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Transaction Completed' LIMIT 1), 'Completed sale — ₱344.00',                      NOW()-INTERVAL'4 days 8 hours',     'Pedro Garcia',        cashier2_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Transaction Completed' LIMIT 1), 'Completed print job — ₱300.00 (thesis)',         NOW()-INTERVAL'7 days 10 hours',    'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Expense Recorded'      LIMIT 1), 'Recorded expense: Electricity — ₱2,500.00',      NOW()-INTERVAL'7 days',             'Jose Reyes',          manager_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Inventory Restocked'   LIMIT 1), 'Restocked A4 Bond Paper: +10 reams',             NOW()-INTERVAL'8 days',             'Jose Reyes',          manager_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Transaction Completed' LIMIT 1), 'Completed sale — ₱494.00 (bulk + printing)',     NOW()-INTERVAL'10 days 11 hours',   'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Expense Recorded'      LIMIT 1), 'Recorded expense: Store restock — ₱3,800.00',    NOW()-INTERVAL'11 days',            'Jose Reyes',          manager_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Inventory Adjusted'    LIMIT 1), 'Stock adjustment: Skyflakes Crackers -15 (spoilage)', NOW()-INTERVAL'10 days',       'Daniel David Lupase', owner_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Transaction Completed' LIMIT 1), 'Completed print job — ₱490.00 (research paper)', NOW()-INTERVAL'14 days 10 hours',  'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Customer Registered'   LIMIT 1), 'New customer: Grace Ocampo',                     NOW()-INTERVAL'15 days',            'Maria Santos',        cashier_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Expense Recorded'      LIMIT 1), 'Recorded expense: Printer inks — ₱4,000.00',     NOW()-INTERVAL'19 days',            'Jose Reyes',          manager_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Expense Recorded'      LIMIT 1), 'Recorded expense: Printer paper — ₱2,880.00',    NOW()-INTERVAL'22 days',            'Jose Reyes',          manager_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'User Created'          LIMIT 1), 'New cashier account created: pedro_cashier',      NOW()-INTERVAL'25 days',            'Daniel David Lupase', owner_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Expense Recorded'      LIMIT 1), 'Recorded expense: Store restock — ₱7,700.00',    NOW()-INTERVAL'25 days',            'Jose Reyes',          manager_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'Expense Recorded'      LIMIT 1), 'Recorded expense: Salaries — ₱25,000.00',        NOW()-INTERVAL'28 days',            'Daniel David Lupase', owner_pid),
    ((SELECT id FROM activity_actions WHERE action_name = 'User Login'            LIMIT 1), 'User logged in',                                  NOW()-INTERVAL'4 hours',            'Maria Santos',        cashier_pid);

END $$;
