use mobileDatabase;

insert into mobileClassify values
(1, 'iOS 手机'),
(2, 'Android 手机');

insert into mobileForm values
('A2223', 'Apple iPhone11', '苹果公司', 5999, '128G 黑色', 'apple1.jpg', 1),
('A1699', 'Apple iPhone6s plus', '苹果公司', 5999, '128G 金色', 'apple2.jpg', 1),
('HW987', 'Huawei mate30 Pro', '华为公司', 5798, '128G 黑色', 'huawei1.jpg', 2),
('HW658', 'Huawei P30', '华为公司', 4698, '128G 蓝色', 'huawei2.jpg', 2),
('XM123', '小米 9 Pro5G', '小米公司', 4398, '128G 蓝色', 'xiaomi1.jpg', 2),
('XM567', '红米 note8', '小米公司', 1099, '64G 红色', 'xiaomi2.jpg', 2);

select * from mobileClassify;
select * from mobileForm;