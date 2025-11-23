create database session12_lt2;
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

create or replace function fn_check_stock()
    returns trigger as $$
declare
    current_stock int;
begin
    -- Lấy tồn kho hiện tại của sản phẩm
    select stock into current_stock
    from products
    where product_id = NEW.product_id;

    -- Nếu không tìm thấy sản phẩm
    if current_stock is null then
        raise exception 'Product % does not exist', NEW.product_id;
    end if;

    -- Kiểm tra tồn kho
    if NEW.quantity > current_stock then
        raise exception 'Khong du trong kho. Hien tai = %, Can = %',
            current_stock, NEW.quantity;
    end if;

    return NEW;  -- Cho phép INSERT tiếp tục
end;
$$ language plpgsql;

create trigger trg_check_stock
    before insert on sales
    for each row
execute function fn_check_stock();

insert into products(name, stock)
values
    ('iPhone 15', 10),
    ('Macbook Pro', 5);


insert into sales(product_id, quantity)
values (1, 3);

select *
from sales;
select *
from products;

insert into sales(product_id, quantity)
values (1, 20);
