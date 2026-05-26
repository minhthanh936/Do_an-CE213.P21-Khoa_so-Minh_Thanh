**Report Đồ án môn Thiết kế hệ thống số với HDL lớp CE213.P21**

**Nhóm Phạm Minh Thanh**

1. Thông tin nhóm  
1. Các thành viên

22521359 – Phạm Minh Thanh

2. Phân bổ công việc

| Thành viên | Nhiệm vụ |
| :---- | :---- |
| Phạm Minh Thanh | Viết FSM Viết decoder LED 7 đoạn Viết các lôgic khác Kiểm thử mô phỏng dạng sóng và trên kit |

2. Đề tài

Hiện thực một khoá số điện tử với các chức năng thông dụng thực tế trên board DE2

3. Thiết kế  
1. Chức năng  
- Đặt mật khẩu  
- Nhập mật khẩu đúng với mật khẩu đã đặt thì mở khóa  
- Nhập sai nhiều lần thì không cho nhập nữa  
- Hiện thị mật khẩu đang nhập  
- Phím Backspace  
2. Mã nguồn

(Xem trong file LOCK.v (chính) và file DECODER\_7segment\_Binary\_to\_Decimal.v)

3. Giải thích các trạng thái và các IO

| localparam \[2:0\] SET \= 3'b000; |
| :---- |
| localparam \[2:0\] VERIFY \= 3'b001; |
| localparam \[2:0\] FREEZE \= 3'b010; |
| localparam \[2:0\] UNLOCKED \= 3'b011; |

Khóa này có 4 chế độ:

SET dùng để đặt lại mật khẩu khi mình cần hoặc khi khóa bị FREEZE mình đặt lại. Nhấn reset\_pass để vào chế độ này từ bất kì chế độ nào. Nhập xong mật khẩu cần đặt thì vào VERIFY.

VERIFY chế độ nhập mật khẩu. Nhập sai nhiều quá thì bị FREEZE (sai 4 lần), nhập đúng thì vào chế độ UNLOCKED.

UNLOCKED chế độ mở khóa. Để khóa lại (vào lại VERIFY) thì ấn enter hoặc back.

FREEZE không cho nhập nữa, chỉ vào chế độ SET được thôi.

| input enter, input back, input \[3:0\]in\_pass, input reset\_pass, |
| :---- |
| output \[6:0\]show\_number0, output \[6:0\]show\_number1, output \[6:0\]show\_number2, output \[6:0\]show\_number3, output LED\_SET, output LED\_VERIFY, output LED\_FREEZE, output lock, output button\_anti |

Các input gồm: enter để nhập 1 chữ số thập phân hoặc lock lại cửa (UNLOCKED-\> VERIFY), back để xóa chữ số hoặc lock lại cửa, reset\_pass để vào chế độ SET, in\_ pass là chữ số nhập vào.

Các output gồm: show\_number0 đến 3 là các chữ số đã nhập, hiện thị trên 4 ô LED 7 đoạn. LED\_SET, LED\_VERIFY, LED\_FREEZE, lock cho ta biết chế độ của khóa. button\_anti sáng khi nhấn 1 nút (enter, back, reset\_pass).

DECODER\_7segment\_Binary\_to\_Decimal là module decode cho các ô LED 7 đoạn hiện số đang nhập.

4. Mô tả hành vi

reset\_pass dùng để đặt (lại) mật khẩu. Ta có thể tưởng tượng nó trên thực tế sẽ được kích hoạt bằng 1 chìa khóa vật lý để người dùng đặt mật khẩu ban đầu hoặc đặt lại mật khẩu. Nó còn có tác dụng đưa khóa ra khỏi trạng thái FREEZE (do nhập sai mật khẩu 4 lần).

\[3:0\]in\_pass là chữ số mà ta muốn nhập. Nhấn phím enter để nhập chữ số vào khóa. Các chữ số đã nhập sẽ hiện thị trên các ô LED 7 đoạn. Khi nhấn đủ 4 chữ số, khi nhấn tiếp thì khóa sẽ đặt 4 chữ số đó làm mật khẩu nếu ở chế độ SET. Còn nếu ở chế độ VERIFY thì khóa sẽ kiểm tra với mật khẩu đã lưu,, đúng thì chế độ UNLOCKED, sai sẽ tăng biến try lên 1\. Nếu sai 4 lần (try==4) thì vào FREEZE, không cho nhập nữa trừ khi reset\_pass lại.

anti\_button dùng để chống lại việc khóa tưởng một sự nhấn phím là nhấn nhiều lần. Nó còn truyền cho output button\_anti sáng khi nhấn phím.

4. Kết quả  
1. Mô phỏng

(Ảnh)

2. Kiểm tra trên kit

https://drive.google.com/file/d/1N\_TnypIV13T9uOi9i4Sq6NohXsGMga1T/view?usp=sharing
