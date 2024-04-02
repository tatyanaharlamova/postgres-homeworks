-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)

SELECT cu.company_name, CONCAT(first_name, ' ', last_name)
FROM orders AS o
JOIN employees As e USING (employee_id)
JOIN customers AS cu USING (customer_id)
JOIN shippers AS s ON o.ship_via = s.shipper_id
WHERE cu.city = 'London' AND e.city = 'London' AND s.company_name ='United Package'

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.

SELECT pr.product_name, pr.units_in_stock, sup.contact_name, sup.phone
FROM products AS pr
JOIN suppliers AS sup USING (supplier_id)
JOIN categories AS cat USING (category_id)
WHERE pr.discontinued <> 1 AND pr.units_in_stock < 25 AND cat.category_name IN ('Dairy Products', 'Condiments')
ORDER BY pr.units_in_stock

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа

SELECT cu.company_name
FROM customers AS cu
LEFT JOIN orders as o USING (customer_id)
WHERE o.order_id IS NULL

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.

SELECT pr.product_name
FROM products AS pr
WHERE EXISTS (SELECT 1 FROM order_details AS od
			 WHERE pr.product_id = od.product_id
			 AND od.quantity = 10)