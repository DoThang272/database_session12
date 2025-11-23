create table accounts(
    acc_id serial primary key ,
    acc_name varchar(50),
    balance numeric
);
insert into accounts(acc_name, balance) values
                                            ('Alice', 1000),
                                            ('Bob', 500);

select * from accounts;


begin;

-- Kiểm tra số dư tài khoản gửi
do $$
    declare sender_balance numeric;
    begin
        select balance into sender_balance from accounts where acc_id = 1;
        if sender_balance < 300 then
            raise exception 'Khong du tien!';
        end if;
    end $$;

-- Trừ tiền tài khoản gửi
update accounts
set balance = balance - 300
where acc_id = 1;

-- Cộng tiền tài khoản nhận
update accounts
set balance = balance + 300
where acc_id = 2;

commit;

select * from accounts;

begin;

do $$
    declare sender_balance numeric;
    begin
        select balance into sender_balance from accounts where acc_id = 2;
        if sender_balance < 2000 then
            raise exception 'Not enough balance!';
        end if;
    end $$;

-- Nếu exception xảy ra → PostgreSQL sẽ tự rollback
rollback;

select * from accounts;