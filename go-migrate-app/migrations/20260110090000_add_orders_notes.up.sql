ALTER TABLE orders ADD COLUMN notes TEXT NOT NULL;

CREATE INDEX idx_orders_status ON orders (status);
