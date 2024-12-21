import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import thư viện intl
import '../../models/tour.dart';
import '../../services/tour_service.dart';
import 'tour_add_page.dart';
import 'tour_detail_page.dart';
import 'tour_edit_page.dart';

class TourListPage extends StatefulWidget {
  @override
  _TourListPageState createState() => _TourListPageState();
}

class _TourListPageState extends State<TourListPage> {
  late Future<List<Tour>> tours;

  @override
  void initState() {
    super.initState();
    tours = ApiService().fetchTours();
  }

  void _deleteTour(Tour tour) async {
    bool success = await ApiService().deleteTour(tour.id);
    if (success) {
      setState(() {
        tours = ApiService().fetchTours();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tour đã được xóa'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Xóa tour thất bại'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Tour'),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: FutureBuilder<List<Tour>>(
        future: tours,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có tour nào.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Tour tour = snapshot.data![index];
              // Định dạng ngày từ DateTime thành chuỗi
              String startDateFormatted = DateFormat('dd/MM/yyyy').format(tour.startDate);
              String endDateFormatted = DateFormat('dd/MM/yyyy').format(tour.endDate);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/${tour.img}', // Make sure the image path is correct
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    tour.tourName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$startDateFormatted - $endDateFormatted', // Display formatted dates
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      // Hiển thị tên danh mục
                      if (tour.category != null)
                        Text(
                          'Danh mục: ${tour.category!.categoryName}',
                          style: TextStyle(color: Colors.grey[800], fontSize: 14),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TourEditPage(tour: tour),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTour(tour),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourDetailPage(tour: tour),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TourAddPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

