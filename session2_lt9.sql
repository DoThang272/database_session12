create database session12_lt4;
create table products(
     product_id serial primary key ,
     name varchar(50),
     stock int
);
create table orders(
    order_id serial primary key ,
    product_id int references products(product_id),
    quantity int,
    total_amount numeric(10,2)
);

alter table products
add column price numeric(10,2);

insert into products(name, stock, price) values
('iPhone 15', 10, 25000000),
('Macbook Pro', 5, 40000000);

create or replace function fn_calculate_total()
    returns trigger as $$
declare
    product_price numeric(10,2);
begin
    -- Lấy giá của sản phẩm
    select price
    into product_price
    from products
    where product_id = NEW.product_id;

    if product_price is null then
        raise exception 'Product % does not exist or has no price', NEW.product_id;
    end if;

    -- Tính total_amount = price × quantity
    NEW.total_amount := product_price * NEW.quantity;

    return NEW;  -- Vì là BEFORE INSERT nên cần return NEW
end;
$$ language plpgsql;

create trigger trg_calculate_total
    before insert on orders
    for each row
execute function fn_calculate_total();
insert into orders(product_id, quantity)
values
    (1, 2),  -- iPhone 15
    (2, 1);  -- Macbook Pro
select * from orders;
