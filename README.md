# F5_231A010308 - Danh sách và lưới trong Flutter

Sinh viên: Nguyễn Phạm Chí Thành - MSSV 231A010308 - Lớp CNTT-LTDD

## Bài nâng cao

**NC3 - SnackBar "Hoàn tác" sau khi xóa:** Trước khi xóa lưu lại vị trí và phần tử.
Sau khi xóa hiện SnackBar có nút "Hoàn tác"; bấm vào thì chèn món lại đúng vị trí cũ bằng
`setState(() => _ds.insert(viTri, sp))`.

**NC4 - Lưới tự đổi số cột:** Đổi `SliverGridDelegateWithFixedCrossAxisCount` thành
`SliverGridDelegateWithMaxCrossAxisExtent`. Mỗi ô có chiều rộng tối đa cố định,
Flutter tự tính số cột theo bề ngang màn hình (dọc ít cột, xoay ngang nhiều cột hơn).