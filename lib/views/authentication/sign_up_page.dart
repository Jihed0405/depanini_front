import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:depanini/constants/color.dart';
import 'package:depanini/services/authenticationApi.dart';
import 'package:depanini/views/authentication/login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthenticationApi _authenticationApi = AuthenticationApi();
  final _formKey = GlobalKey<FormState>();
 bool _editIconVisible = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  int _currentStep = 0;
  String _userType = 'CLIENT';
  File? _image;
  String? _photoUrl;
  bool _isImagePickerActive = false;
  final ImagePicker _picker = ImagePicker();
  double _uploadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: selectedPageColor,
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userType = 'CLIENT';
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _userType == 'CLIENT' ? Color(0xFFEBAB01) : Colors.transparent,
                        ),
                        child: Icon(Icons.person, size: 30, color: _userType == 'CLIENT' ? Colors.white : Colors.black),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _userType = 'SERVICE_PROVIDER';
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _userType == 'SERVICE_PROVIDER' ? Color(0xFFEBAB01) : Colors.transparent,
                        ),
                        child: Icon(Icons.build, size: 30, color: _userType == 'SERVICE_PROVIDER' ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Container(
                  height: 400,
                  child: _buildStepContent(),
                ),
                SizedBox(height: 20),
                _buildStepIndicator(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_currentStep < 2) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        _submitForm();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFEBAB01),
                    onPrimary: Colors.white,
                  ),
                  child: Text(_currentStep < 2 ? 'Next' : 'Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => _onDotTapped(0),
          child: _buildStepDot(0),
        ),
        GestureDetector(
          onTap: () => _onDotTapped(1),
          child: _buildStepDot(1),
        ),
        GestureDetector(
          onTap: () => _onDotTapped(2),
          child: _buildStepDot(2),
        ),
      ],
    );
  }

  Widget _buildStepDot(int step) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentStep >= step ? Color(0xFFEBAB01) : Colors.grey,
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return SingleChildScrollView(child: 
        _buildStep1Content());
      case 1:
        return _buildStep2Content();
      case 2:
        return _buildStep3Content();
      default:
        return Container();
    }
  }

  void _onDotTapped(int step) {
    //if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep = step;
      });
  //  }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
    );
  }

  Widget _buildStep1Content() {
    
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: _inputDecoration('Username', Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: _inputDecoration('Password', Icons.lock),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _firstNameController,
            decoration: _inputDecoration('First Name', Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'First name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _lastNameController,
            decoration: _inputDecoration('Last Name', Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last name is required';
              }
              return null;
            },
          ),
        ],
      );
    
  }

  Widget _buildStep2Content() {
    
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: _inputDecoration('Email', Icons.email),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _phoneNumberController,
            decoration: _inputDecoration('Phone Number', Icons.phone),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                return 'Phone number must be 8 digits';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _addressController,
            decoration: _inputDecoration('Address', Icons.location_on),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
        ],
      );
  }

Widget _buildStep3Content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
             Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _uploadProgress < 1.0 ? Colors.transparent : Color(0xFFEBAB01),
                  width: 4,
                ),
              ),
            child:CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: _image != null ? FileImage(_image!) : null,
            ),),
            if (_uploadProgress > 0)
            Positioned(
                top: -4, // Adjust position to be outside the CircleAvatar
                child: SizedBox(
                  width: 128,
                  height: 128, // Show progress circle if upload progress is greater than 0
             child: CircularProgressIndicator(
                value: _uploadProgress, // Set progress value
                strokeWidth: 4, // Set thickness of the progress circle
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFEBAB01), // Set color of the progress circle
                ),
              ),
                ),
            ),
            if (_editIconVisible) // Show edit icon based on the flag
              Container(
              
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _pickImage,
                ),
              ),
          ],
        ),
        SizedBox(height: 20),
        if (_userType == 'SERVICE_PROVIDER') ...[
          TextFormField(
            controller: _bioController,
            decoration: _inputDecoration('Bio', Icons.description),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bio is required for service providers';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _experienceController,
            decoration: _inputDecoration('Number of Experiences', Icons.work),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Number of experiences is required for service providers';
              } else if (int.tryParse(value) == null) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),
        ],
        SizedBox(height: 20),
        _image != null // Show upload button only if image is selected
            ? ElevatedButton.icon(
                onPressed: () {
                  if (_editIconVisible) {
                    _confirmImage();
                    setState(() {
                      _editIconVisible = false; // Hide edit icon after upload button is clicked
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFEBAB01),
                  onPrimary: Colors.white,
                ),
                icon: Icon(Icons.cloud_upload), // Icon for upload action
                label: Text('Upload Photo'), // Text for upload action
              )
            : SizedBox(), // Placeholder if no image selected
      ],
    );
  }



  Future<void> _pickImage() async {
    if (_isImagePickerActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image picker is already active')),
      );
      return;
    }
    _isImagePickerActive = true;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    _isImagePickerActive = false;
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _confirmImage() {
    if (_image != null) {
      setState(() {
        _uploadProgress = 0.0;
      });

      _uploadImage(_image!).then((_) {
        setState(() {
          _uploadProgress = 1.0;
        });
      });

      setState(() {
        _uploadProgress = 0.5;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
    }
  }

  Future<void> _uploadImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.imgur.com/3/image'),
    );
    request.headers['Authorization'] = 'Client-ID 6e76c5be01f9c0d';
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print("Image upload status ${response.statusCode}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _photoUrl = jsonResponse['data']['link'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed!')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_areFieldsValid()) {
      try {
        if (_userType == 'CLIENT') {
          await _authenticationApi.signUpClient(
            _usernameController.text,
            _passwordController.text,
            _firstNameController.text,
            _lastNameController.text,
            _emailController.text,
            _phoneNumberController.text,
            _addressController.text,
            _photoUrl!,
          );
        } else {
          await _authenticationApi.signUpServiceProvider(
            _usernameController.text,
            _passwordController.text,
            _firstNameController.text,
            _lastNameController.text,
            _emailController.text,
            _phoneNumberController.text,
            _addressController.text,
            _bioController.text,
            int.parse(_experienceController.text),
            _photoUrl!,
          );
        }
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('registered successfully')),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      } catch (e) {
        print('Error during signup: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during signup: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields must be filled.')),
      );
    }
  }

  bool _areFieldsValid() {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _photoUrl == null ||
        (_userType == 'SERVICE_PROVIDER' &&
            (_bioController.text.isEmpty || _experienceController.text.isEmpty))) {
      return false;
    }
    return true;
  }
}
