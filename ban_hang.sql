-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th5 26, 2026 lúc 10:58 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `ban_hang`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `image_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`id`, `name`, `image_url`) VALUES
(1, 'Điện Thoại & Laptop', 'https://img.freepik.com/free-photo/workplace-business-modern-technology-concept_53876-123530.jpg'),
(2, 'Thời Trang Nam/Nữ', 'https://img.freepik.com/free-photo/clothing-rack-with-casual-clothes_23-2148174542.jpg'),
(3, 'Phụ Kiện Cao Cấp', 'https://img.freepik.com/free-photo/top-view-accessories-arrangement_23-2148878471.jpg'),
(4, 'Giày Dép & Túi Xách', 'https://img.freepik.com/free-photo/fashion-shoes-sneakers_1203-7529.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `total_amount` double NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','confirmed','shipping','delivered','cancelled') DEFAULT 'pending',
  `shipping_address` text DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT 'COD'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `order_date`, `status`, `shipping_address`, `phone`, `payment_method`) VALUES
(1, 3, 32000000, '2026-04-16 14:20:51', 'delivered', 'thanh hóa', '0364304676', 'COD'),
(2, 3, 58500000, '2026-04-16 16:33:45', 'delivered', 'thanh hóa', '0364304676', 'COD'),
(3, 3, 32000000, '2026-04-23 00:49:08', 'delivered', 'thanh hóa', '0364304676', 'COD'),
(4, 3, 32000000, '2026-04-23 02:06:35', '', 'thanh hóa', '0364304676', 'COD'),
(5, 5, 26500000, '2026-04-23 03:17:29', '', 'sóc sơn', '0123456789', 'COD'),
(6, 3, 32000000, '2026-04-23 03:32:27', 'delivered', 'thanh hóa', '0364304676', 'COD'),
(7, 3, 32000000, '2026-04-23 03:37:18', 'delivered', 'thanh hóa', '0364304676', 'COD'),
(8, 3, 26500000, '2026-04-25 00:38:08', 'pending', 'thanh hóa', '0364304676', 'COD'),
(9, 3, 32000000, '2026-04-25 00:43:35', 'delivered', 'thanh hóa', '0364304676', 'COD'),
(10, 4, 32000000, '2026-04-25 00:45:36', 'cancelled', 'sóc\n', '034649684', 'COD'),
(11, 3, 26500000, '2026-04-25 01:10:51', 'pending', 'thanh hóa', '0364304676', 'COD'),
(12, 3, 320000, '2026-04-25 01:24:54', 'pending', 'thanh hóa', '0364304676', 'COD'),
(13, 3, 32000000, '2026-05-26 08:44:43', 'pending', 'thanh hóa', '036430467', 'COD');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_details`
--

CREATE TABLE `order_details` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order_details`
--

INSERT INTO `order_details` (`id`, `order_id`, `product_id`, `quantity`, `unit_price`) VALUES
(1, 1, 1, 1, 32000000),
(2, 2, 1, 1, 32000000),
(3, 2, 2, 1, 26500000),
(4, 3, 1, 1, 32000000),
(5, 4, 1, 1, 32000000),
(6, 5, 2, 1, 26500000),
(7, 6, 1, 1, 32000000),
(8, 7, 1, 1, 32000000),
(9, 8, 2, 1, 26500000),
(10, 9, 1, 1, 32000000),
(11, 10, 1, 1, 32000000),
(12, 11, 2, 1, 26500000),
(13, 12, 4, 1, 320000),
(14, 13, 1, 1, 32000000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `old_price` double DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `is_popular` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `price`, `old_price`, `description`, `image_url`, `stock_quantity`, `is_popular`) VALUES
(1, 1, 'iPhone 15 Pro Max', 32000000, 35000000, 'Chip A17 Pro mạnh mẽ, camera 48MP, khung viền Titan siêu bền.', 'https://hanoicomputercdn.com/media/product/76341_natural_titanium_update__3_.jpg', 10, 1),
(2, 1, 'MacBook Air M2', 26500000, 28900000, 'Thiết kế mỏng nhẹ, hiệu năng cực đỉnh với chip M2, màn hình Liquid Retina.', 'https://www.apple.com/v/macbook-air-13-and-15-m2/a/images/overview/design/design-hero_endframe__olurqzgtbh6e_large.jpg', 3, 1),
(3, 2, 'Áo Khoác Bomber Streetwear', 450000, 650000, 'Chất liệu vải dù cao cấp, phong cách trẻ trung, phù hợp cả nam và nữ.', 'https://down-vn.img.susercontent.com/file/efec35aa8f840f841fcfacf376bc837b_tn', 50, 1),
(4, 2, 'Váy Hoa Nhí Vintage', 320000, 450000, 'Váy chất liệu voan mềm mại, hoa nhí nhẹ nhàng nữ tính cho mùa hè.', 'https://th.bing.com/th/id/OIP.godTRlGpPEG9gDXAeK_lWAHaHa?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', 29, 0),
(5, 2, 'Quần Jeans Slim Fit', 380000, 550000, 'Chất jeans co giãn nhẹ, giữ form tốt, không phai màu khi giặt.', 'https://tse1.mm.bing.net/th/id/OIP.V0qIZKPIDxBZ_bEBlt3WdAHaLH?rs=1&pid=ImgDetMain&o=7&rm=3', 40, 1),
(6, 3, 'Đồng Hồ Apple Watch Series 9', 9500000, 11000000, 'Theo dõi sức khỏe, màn hình Always-on, tích hợp GPS thông minh.', 'https://down-vn.img.susercontent.com/file/vn-11134207-7r98o-ln9aoepv6hg8c5', 15, 1),
(7, 3, 'Kính Mát Phi Công Classic', 550000, 850000, 'Chống tia UV400, gọng kim loại mạ vàng sang trọng, bảo vệ mắt tối đa.', 'https://th.bing.com/th/id/OIP.0zJqKkS7Tlw56QxF0yufgQHaHa?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', 100, 0),
(8, 3, 'Thắt Lưng Da Bò Thật', 350000, 500000, 'Da bò nguyên tấm cao cấp, mặt khóa kim loại không rỉ.', 'https://hoianleather.com/wp-content/uploads/2021/08/That-lung-da-bo-that.jpg', 200, 0),
(9, 4, 'Giày Sneaker Nike Air Force 1', 2800000, 3200000, 'Huyền thoại phong cách, dễ phối đồ, đế đệm Air cực êm.', 'https://th.bing.com/th/id/R.bd4104b5a81ee2a4cefaefa66f6751c2?rik=yLoP7BkhiKXpoQ&pid=ImgRaw&r=0', 20, 1),
(10, 4, 'Túi Xách Nữ Chanel Luxury', 5500000, 7000000, 'Thiết kế sang trọng, da chần bông bền bỉ, phụ kiện kim loại sáng bóng.', 'https://tse2.mm.bing.net/th/id/OIP.JgE2kIAVAsxsreUQEDkRwwHaHa?rs=1&pid=ImgDetMain&o=7&rm=3', 8, 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `phone`, `address`, `created_at`, `role`) VALUES
(1, 'admin', '123', 'Quản Trị Viên', 'admin@gmail.com', '0987654321', 'Hà Nội, Việt Nam', '2026-04-16 14:09:08', 1),
(2, 'user', '123', 'Nguyễn Văn Khách', 'user@gmail.com', '0123456789', 'TP. Hồ Chí Minh', '2026-04-16 14:09:08', 0),
(3, 'tấn', '$2y$10$h9WkxKP..SyvqAsfob1/0uGMn0wvJSegKVMiTH2DK3FhMCXv/D706', 'hoàng tấn', 'hoangtan17122004a5@gmail.com', '036430467', 'thanh hóa', '2026-04-16 14:12:11', 1),
(4, 'cương', '$2y$10$DTqL.kR.AZpG6k5mHKbtFe/WDEeSMJzIojvD/P2O8l5Ql71lsgM3K', 'hoàng cương', 'cuong@gmail.com', '034649684', 'sóc\n', '2026-04-16 14:25:14', 0),
(5, 'Cương Ngu', '$2y$10$x7t7UE2p6uDZoHNVaDykKOUdFodwHqrSay7EVBD0caAOLUP6mOJHG', 'Hoàng Kiên Cương ', 'cuonglon@gmail.com', '0123456789', 'đáy xã hội', '2026-04-23 03:08:57', 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Các ràng buộc cho bảng `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
