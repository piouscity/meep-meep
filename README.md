# meep-meep
Đồ án 2 của môn KTMT&amp;HN. Lập trình bằng hợp ngữ, trên kiến trúc MIPS / Míp / Meep
## Pseudo instructions
https://github.com/MIPT-ILab/mipt-mips/wiki/MIPS-pseudo-instructions
## Quy ước
### Về tổ chức github
- Mỗi file chỉ chứa một hàm
- Thằng nào code hàm nào thì kéo note qua thôi, khỏi cần convert to issue (trừ khi cần thảo luận)
### Về code
- Nên chú thích một số chỗ cần thiết :))
- Chú thích tiếng việt không dấu
- Các thanh ghi save *($s0, $s1, $s2, ....)* nếu có xài thì **phải** backup vào vùng nhớ stack trước khi ghi dữ liệu vô.
- Các thanh ghi temp *($t0, $t1, $t2, ....)* khi xài thì **không cần** backup, cứ thế mà ghi dữ liệu vô thôi.
- Trong main: ngày tháng năm được lưu vào $s0, $s1, $s2. Địa chỉ của chuỗi time được lưu trong $s3.
- Trong hàm: 
  + Nếu có sử dụng $s thì phải backup.
  + Nếu có gọi hàm khác thì phải backup $a nếu như dữ liệu trong $a còn xài lại.
  + Luôn backup $ra
