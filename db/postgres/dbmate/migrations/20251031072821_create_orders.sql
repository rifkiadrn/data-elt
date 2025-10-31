-- migrate:up
CREATE TABLE IF NOT EXISTS data_elt.orders (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES data_elt.users(id) ON DELETE NO ACTION,
  order_date TIMESTAMP,
  status TEXT,
  total_amount NUMERIC(10,2),
  currency TEXT,
  payment_method TEXT,
  shipping_city TEXT,
  shipping_country TEXT,
  created_at BIGINT NOT NULL DEFAULT DATE_PART('EPOCH', NOW()),
  updated_at BIGINT NOT NULL DEFAULT DATE_PART('EPOCH', NOW())
);


-- migrate:down
DROP TABLE IF EXISTS data_elt.orders;
