import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.loggedInUser;

    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1B2631),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: user == null
          ? Center(
        child: Text(
          "No user logged in",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // ✅ Profile Picture with Default Image
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/12345.jpg"),
              ),

              SizedBox(height: 20),

              // ✅ Profile Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color(0xFF34495E),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildEditableProfileDetail(
                          Icons.person, "Name", user.firstName, user.lastName),
                      _buildProfileDetail(Icons.phone, "Phone", "${user.phone}"),
                      _buildProfileDetail(Icons.email, "Email", "${user.email}"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // ✅ Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  authViewModel.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Editable Profile Detail
  Widget _buildEditableProfileDetail(
      IconData icon, String label, String firstName, String lastName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditingName = true;
          _nameController = TextEditingController(text: "$firstName $lastName");
        });
        _showEditNameDialog();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B2631),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "$firstName $lastName",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight:
                    _isEditingName ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Profile Details with Icons
  Widget _buildProfileDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Edit Name Dialog
  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2C3E50),
          title: Text(
            "Edit Name",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new name",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlueAccent),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                _saveEditedName();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  // ✅ Save Edited Name
  void _saveEditedName() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (_nameController.text.trim().isEmpty) return;

    List<String> nameParts = _nameController.text.trim().split(" ");
    String firstName = nameParts.first;
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

    await authViewModel.updateUserName(firstName, lastName);

    setState(() {
      _isEditingName = false;
    });
  }
}



/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.loggedInUser;

    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1B2631),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: user == null
          ? Center(
        child: Text(
          "No user logged in",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // ✅ Profile Picture with Network Image
              CircleAvatar(
                radius: 60,
                backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                    ? NetworkImage(user.profileImage!) // ✅ User's Uploaded Image
                    : NetworkImage('https://picsum.photos/200'), // ✅ Default Network Image
              ),

              SizedBox(height: 20),

              // ✅ Profile Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color(0xFF34495E),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildEditableProfileDetail(
                          Icons.person, "Name", user.firstName, user.lastName),
                      _buildProfileDetail(Icons.phone, "Phone", "${user.phone}"),
                      _buildProfileDetail(Icons.email, "Email", "${user.email}"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // ✅ Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  authViewModel.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Editable Profile Detail
  Widget _buildEditableProfileDetail(
      IconData icon, String label, String firstName, String lastName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditingName = true;
          _nameController = TextEditingController(text: "$firstName $lastName");
        });
        _showEditNameDialog();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B2631),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 28),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "$firstName $lastName",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight:
                    _isEditingName ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Profile Details with Icons
  Widget _buildProfileDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Edit Name Dialog
  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2C3E50),
          title: Text(
            "Edit Name",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter new name",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlueAccent),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                _saveEditedName();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        );
      },
    );
  }

  // ✅ Save Edited Name
  void _saveEditedName() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (_nameController.text.trim().isEmpty) return;

    List<String> nameParts = _nameController.text.trim().split(" ");
    String firstName = nameParts.first;
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

    await authViewModel.updateUserName(firstName, lastName);

    setState(() {
      _isEditingName = false;
    });
  }
}
*/



/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late TextEditingController _nameController;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize animation
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // ✅ Start animation when screen loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.loggedInUser;

    return Scaffold(
      backgroundColor: Color(0xFF2C3E50), // ✅ Dark-Blue Gray Theme
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white, // ✅ White Profile Title
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1B2631), // ✅ Dark AppBar
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: user == null
          ? Center(
        child: Text(
          "No user logged in",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : ScaleTransition(
        scale: _scaleAnimation, // ✅ Smooth scale-in animation
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // ✅ Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/default_profile.jpeg"),
              ),

              SizedBox(height: 20),

              // ✅ Profile Card with User Details
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color(0xFF34495E), // ✅ Dark Blue Card
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildEditableProfileDetail(
                          Icons.person, "Name", user.firstName, user.lastName),
                      _buildProfileDetail(
                          Icons.phone, "Phone", "${user.phone}"),
                      _buildProfileDetail(
                          Icons.email, "Email", "${user.email}"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // ✅ Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  authViewModel.logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Method for Editable Name Field
  Widget _buildEditableProfileDetail(IconData icon, String label, String firstName, String lastName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditingName = true;
          _nameController = TextEditingController(text: "$firstName $lastName");
        });
        _showEditNameDialog();
      },
      child: _buildProfileDetail(icon, label, "$firstName $lastName"),
    );
  }

  // ✅ Method for Profile Details with Icons
  Widget _buildProfileDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey, // ✅ Grey Label
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // ✅ White Value Text
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Show Edit Name Dialog
  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Name"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                _saveEditedName();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // ✅ Save Edited Name to Database
  void _saveEditedName() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (_nameController.text.trim().isEmpty) return;

    List<String> nameParts = _nameController.text.trim().split(" ");
    String firstName = nameParts.first;
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

    await authViewModel.updateUserName(firstName, lastName);

    setState(() {
      _isEditingName = false;
    });
  }
}
*/


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize smooth animation
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // ✅ Start animation when screen loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.loggedInUser;

    return Scaffold(
      backgroundColor: Color(0xFF2C3E50), // ✅ Dark-Blue Gray Theme
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white, // ✅ White Profile Title
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1B2631), // ✅ Dark AppBar
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: user == null
          ? Center(
        child: Text(
          "No user logged in",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : ScaleTransition(
        scale: _scaleAnimation, // ✅ Smooth scale-in animation
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // ✅ Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/default_profile.jpeg"),
              ),

              SizedBox(height: 20),

              // ✅ Profile Card with User Details
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color(0xFF34495E), // ✅ Dark Blue Card
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildProfileDetail(Icons.person, "Name",
                          "${user.firstName} ${user.lastName}"),
                      _buildProfileDetail(
                          Icons.phone, "Phone", "${user.phone}"),
                      _buildProfileDetail(
                          Icons.email, "Email", "${user.email}"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // ✅ Logout Button
              ElevatedButton.icon(
                onPressed: () {
                  authViewModel.logout();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Method for Profile Details with Icons (White Text)
  Widget _buildProfileDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey, // ✅ White Label
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // ✅ White Value Text
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize smooth animation
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 600));

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // ✅ Start animation when screen loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.loggedInUser;

    return Scaffold(
      backgroundColor: Colors.blue[50], // ✅ Same background as login page
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: user == null
          ? Center(child: Text("No user logged in"))
          : Center(
        child: ScaleTransition(
          scale: _scaleAnimation, // ✅ Smooth scale-in animation
          child: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Centered Profile Image
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: AssetImage(
                        "assets/default_profile.jpeg"), // Default profile image
                  ),
                ),
                SizedBox(height: 15),

                // ✅ Profile Details with Icons
                _buildProfileDetail(Icons.person, "Name",
                    "${user.firstName} ${user.lastName}"),
                _buildProfileDetail(Icons.phone, "Phone", "${user.phone}"),
                _buildProfileDetail(Icons.email, "Email", "${user.email}"),

                SizedBox(height: 20),

                // ✅ Logout Button
                ElevatedButton.icon(
                  onPressed: () {
                    authViewModel.logout();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                  },
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Method for Profile Details with Icons
  Widget _buildProfileDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
*/


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize smooth animation
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // ✅ Start animation when screen loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.loggedInUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: user == null
          ? Center(child: Text("No user logged in"))
          : Center(
        child: ScaleTransition(
          scale: _scaleAnimation, // ✅ Smooth scale-in animation
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Profile Image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    AssetImage("assets/default_profile.jpeg"),
                  ),
                  SizedBox(height: 20),

                  // ✅ Profile Details with Icons
                  _buildProfileDetail(
                      Icons.person, "Name", "${user.firstName} ${user.lastName}"),
                  _buildProfileDetail(Icons.phone, "Phone", "${user.phone}"),
                  _buildProfileDetail(Icons.email, "Email", "${user.email}"),

                  SizedBox(height: 20),

                  // ✅ Logout Button
                  ElevatedButton.icon(
                    onPressed: () {
                      authViewModel.logout();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Method for Profile Details with Icons
  Widget _buildProfileDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
*/
