create database session12_lt3
create table products(
                         product_id serial primary key ,
                         name varchar(50),
                         stock int
);
create table sales(
                      sale_id serial primary key ,
                      product_id int references products(product_id),
                      quantity int
);
create or replace function fn_reduce_stock()
    returns trigger as $$
begin
    update products
    set stock = stock - NEW.quantity
    where product_id = NEW.product_id;

    return NEW;  -- trả về bản ghi mới cho trigger
end;
$$ language plpgsql;
create trigger trg_after_sales_insert
    after insert on sales
    for each row
execute function fn_reduce_stock();
insert into products(name, stock)
values
    ('iPhone 15', 10),
    ('Macbook Pro', 5);

insert into sales(product_id, quantity)
values (1, 2);

select * from products;
select *
from sales;

