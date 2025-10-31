-- migrate:up
INSERT INTO data_elt.orders
SELECT
  gen_random_uuid() AS id,
  user_id_list[floor(random() * array_length(user_id_list, 1)) + 1]::uuid AS user_id,
  NOW() - (random() * interval '60 days') AS order_date,
  (ARRAY['pending','paid','shipped','delivered','cancelled'])[floor(random()*5 + 1)] AS status,
  ROUND((random() * 1000 + 50)::numeric, 2) AS total_amount,
  (ARRAY['IDR','USD','MYR'])[floor(random()*3 + 1)] AS currency,
  (ARRAY['credit_card','bank_transfer','ewallet'])[floor(random()*3 + 1)] AS payment_method,
  (ARRAY['Jakarta','Bandung','Surabaya','Medan','Bali'])[floor(random()*5 + 1)] AS shipping_city,
  (ARRAY['Indonesia','Malaysia','Singapore'])[floor(random()*3 + 1)] AS shipping_country,
  EXTRACT(EPOCH FROM NOW())::BIGINT AS created_at,
  EXTRACT(EPOCH FROM NOW())::BIGINT AS updated_at
FROM
  generate_series(1, 500),
  (
    SELECT ARRAY[
      'f81fd9e8-dfec-4880-b86d-cbc7801e3d39',
      'd3ecbce0-bd13-474b-b1c3-6aa09233f75c',
      '5a2abf78-7a07-4630-888f-a7bb9e5313ca',
      '9008026f-f17f-472a-8584-14f6cff770b4',
      '86b9f5c1-0c4a-4ea0-90ac-1ec73c993db1',
      '9db793ef-92c8-4333-9725-a8c46c0d1c71',
      '5041436d-e203-4408-9fe4-839bdc7de189',
      '47e2df44-eabb-46c6-8c5e-fba616ea4adb',
      'ca2c8215-e652-4f3d-a67a-ba47970cc029',
      'e97d298d-2df6-4e32-a06b-5585830689b8',
      'f8e82e10-b84b-4221-81da-89cf341a40a3'
    ] AS user_id_list
  ) u;
-- migrate:down

