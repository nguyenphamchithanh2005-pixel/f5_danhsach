import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F5_231A010308',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0468D7)),
      ),
      home: const HomePage(),
    );
  }
}

// ===================================================================
// MODEL - tách dữ liệu ra khỏi giao diện
// ===================================================================
class SanPham {
  final String ten;
  final String moTa;
  final int gia; // đồng
  final String anh; // đường dẫn asset

  const SanPham({
    required this.ten,
    required this.moTa,
    required this.gia,
    required this.anh,
  });
}

/// "Cơ sở dữ liệu" tạm thời.
final List<SanPham> duLieuMau = [
  const SanPham(
      ten: 'Phở bò tái',
      moTa: 'Nước dùng hầm xương 12 giờ',
      gia: 45000,
      anh: 'assets/images/p1.jpg'),
  const SanPham(
      ten: 'Bún chả Hà Nội',
      moTa: 'Thịt nướng than hoa, nước chấm chua ngọt',
      gia: 50000,
      anh: 'assets/images/p2.jpg'),
  const SanPham(
      ten: 'Cơm tấm sườn',
      moTa: 'Sườn nướng, bì, chả trứng',
      gia: 40000,
      anh: 'assets/images/p3.jpg'),
  const SanPham(
      ten: 'Bánh mì thịt nguội',
      moTa: 'Giòn rụm, pate béo ngậy',
      gia: 25000,
      anh: 'assets/images/p4.jpg'),
  const SanPham(
      ten: 'Trà đào cam sả',
      moTa: 'Mát lạnh, thơm sả',
      gia: 30000,
      anh: 'assets/images/p5.jpg'),
  const SanPham(
      ten: 'Cà phê latte',
      moTa: 'Béo nhẹ, tạo hình hoa văn',
      gia: 45000,
      anh: 'assets/images/p6.jpg'),
];

/// Định dạng 180000 -> "180.000 đ" (không cần thư viện ngoài).
String dinhDangGia(int gia) {
  final s = gia.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '${buf.toString()} đ';
}

// ===================================================================
// Widget ảnh dùng chung
// ===================================================================
class AnhSanPham extends StatelessWidget {
  final String duongDan;
  final double? kichThuoc;

  const AnhSanPham({super.key, required this.duongDan, this.kichThuoc});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      duongDan,
      width: kichThuoc,
      height: kichThuoc,
      fit: BoxFit.cover,
      // Chưa có ảnh thì hiện ô xám thay vì lỗi đỏ
      errorBuilder: (context, error, stackTrace) => Container(
        width: kichThuoc,
        height: kichThuoc,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }
}

// ===================================================================
// KHUNG CHÍNH - 2 tab
// ===================================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tab == 0 ? 'Danh sách sản phẩm' : 'Album ảnh')),
      body: _tab == 0 ? const ProductListTab() : const AlbumTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Danh sách'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Lưới'),
        ],
      ),
    );
  }
}

// ===================================================================
// TAB 1 - ListView.builder + Card + Dismissible (+ NC3 Hoàn tác)
// ===================================================================
class ProductListTab extends StatefulWidget {
  const ProductListTab({super.key});

  @override
  State<ProductListTab> createState() => _ProductListTabState();
}

class _ProductListTabState extends State<ProductListTab> {
  // Bản sao để thêm/xóa mà không đụng vào dữ liệu gốc
  final List<SanPham> _ds = List.of(duLieuMau);
  int _dem = 0;

  void _them() {
    setState(() {
      _dem++;
      _ds.insert(
        0,
        SanPham(
          ten: 'Sản phẩm mới $_dem',
          moTa: 'Vừa được thêm lúc ${TimeOfDay.now().format(context)}',
          gia: 50000 * _dem,
          anh: 'assets/images/p1.jpg',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Danh sách trống'),
            TextButton(onPressed: _them, child: const Text('Thêm sản phẩm')),
          ],
        ),
      );
    }

    return Scaffold(
      // ListView.builder chỉ dựng những item đang nhìn thấy (lazy),
      // giống cách RecyclerView tái sử dụng ViewHolder bên Android.
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _ds.length,
        itemBuilder: (context, index) {
          final sp = _ds[index];
          return Dismissible(
            // key PHẢI duy nhất và ổn định: dùng chính đối tượng dữ liệu,
            // không dùng index vì index đổi khi xóa mục ở giữa
            key: ValueKey(sp),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              // NC3: lưu vị trí để hoàn tác đúng chỗ cũ
              final viTri = index;
              setState(() => _ds.remove(sp));
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();
              messenger.showSnackBar(
                SnackBar(
                  content: Text('Đã xóa ${sp.ten}'),
                  action: SnackBarAction(
                    label: 'Hoàn tác',
                    onPressed: () {
                      setState(() {
                        final p = viTri > _ds.length ? _ds.length : viTri;
                        _ds.insert(p, sp);
                      });
                    },
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: AnhSanPham(duongDan: sp.anh, kichThuoc: 56),
                title: Text(sp.ten, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle:
                    Text(sp.moTa, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Text(
                  dinhDangGia(sp.gia),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bạn chọn: ${sp.ten}')),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: _them, child: const Icon(Icons.add)),
    );
  }
}

// ===================================================================
// TAB 2 - GridView.builder (+ NC4 tự đổi số cột)
// ===================================================================
class AlbumTab extends StatelessWidget {
  const AlbumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      // NC4: mỗi ô rộng tối đa 180 dp, Flutter tự tính số cột
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemCount: duLieuMau.length,
      itemBuilder: (context, index) {
        final sp = duLieuMau[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: AnhSanPham(duongDan: sp.anh)),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sp.ten,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(dinhDangGia(sp.gia),
                        style: const TextStyle(color: Colors.blueGrey)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}