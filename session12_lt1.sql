create database session2_LT1;
create table customers(
    customer_id serial primary key ,
    name varchar(50),
    email varchar(50)
);

create table customer_log(
    log_id serial primary key ,
    customer_name varchar(50),
    action_time timestamp
);

-- Tạo TRIGGER để tự động ghi log khi INSERT vào customers
-- Thêm vài bản ghi vào customers và kiểm tra customer_log

create or replace function fn_log_customer_insert()
returns trigger as $$
begin
    insert into customer_log(customer_name, action_time) values
    (new.name, now());
    return new;
end;
    $$ language plpgsql;

create trigger trg_customer_insert
after insert on customers
for each row
execute function fn_log_customer_insert();

insert into customers(name, email)
values
    ('Nguyen Van A', 'a@gmail.com'),
    ('Tran Thi B', 'b@gmail.com'),
    ('Le Van C', 'c@gmail.com');

select * from customer_log;
