import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/database_service.dart';
import '../models/person.dart';
import '../models/case.dart';

class CaseRegistrationScreen extends StatefulWidget {
  const CaseRegistrationScreen({super.key});

  @override
  State<CaseRegistrationScreen> createState() => _CaseRegistrationScreenState();
}

class _CaseRegistrationScreenState extends State<CaseRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nationalCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  List<Case> cases = [];
  Case? selectedCase;
  String selectedRole = 'متهم';
  bool isLoading = false;

  final List<String> roles = ['متهم', 'شاکی', 'شاهد', 'وکیل'];

  @override
  void initState() {
    super.initState();
    loadCases();
  }

  Future<void> loadCases() async {
    var data = await DatabaseService.getCases();
    setState(() {
      cases = data;
    });
  }

  Future<void> registerPerson() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCase == null) {
      _showSnackBar('لطفاً یک پرونده انتخاب کنید', const Color(0xFFfa709a));
      return;
    }

    setState(() {
      isLoading = true;
    });

    var existingPerson = await DatabaseService.getPersonByNationalCode(
      _nationalCodeController.text,
    );

    int personID;

    if (existingPerson == null) {
      Person newPerson = Person(
        fullName: _nameController.text,
        nationalCode: _nationalCodeController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        personType: selectedRole,
      );

      bool added = await DatabaseService.addPerson(newPerson);

      if (!added) {
        setState(() {
          isLoading = false;
        });
        _showSnackBar('خطا در ثبت شخص', const Color(0xFFfa709a));
        return;
      }

      var addedPerson = await DatabaseService.getPersonByNationalCode(
        _nationalCodeController.text,
      );
      personID = addedPerson!.personID!;
    } else {
      personID = existingPerson.personID!;
    }

    String result = await DatabaseService.addPersonToCase(
      personID,
      selectedCase!.caseID!,
      selectedRole,
      _notesController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (result.contains('موفقیت')) {
      _showSnackBar(result, const Color(0xFF43e97b));
      _showSuccessDialog();
      _clearForm();
      loadCases();
    } else {
      _showSnackBar(result, const Color(0xFFfa709a));
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _nationalCodeController.clear();
    _phoneController.clear();
    _addressController.clear();
    _notesController.clear();
    setState(() {
      selectedCase = null;
      selectedRole = 'متهم';
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => FadeIn(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'موفق!',
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'اطلاعات با موفقیت ثبت شد',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF43e97b),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'باشه',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF11998e),
              Color(0xFF38ef7d),
              Color(0xFF43e97b),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'افزودن شخص به پرونده',
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 200),
                            child: _buildTextField(
                              controller: _nameController,
                              label: 'نام کامل',
                              icon: Icons.person,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFff9966), Color(0xFFff5e62)],
                              ),
                              validator: (v) {
                                if (v!.isEmpty) return 'نام را وارد کنید';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 300),
                            child: _buildTextField(
                              controller: _nationalCodeController,
                              label: 'کد ملی',
                              icon: Icons.badge,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFfa709a), Color(0xFFfee140)],
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              validator: (v) {
                                if (v!.isEmpty) return 'کد ملی را وارد کنید';
                                if (v.length != 10) return 'کد ملی باید 10 رقم باشد';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 400),
                            child: _buildTextField(
                              controller: _phoneController,
                              label: 'شماره تماس',
                              icon: Icons.phone,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                              ),
                              keyboardType: TextInputType.phone,
                              maxLength: 11,
                            ),
                          ),
                          const SizedBox(height: 15),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 500),
                            child: _buildTextField(
                              controller: _addressController,
                              label: 'آدرس',
                              icon: Icons.location_on,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 600),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF667eea).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: selectedRole,
                                  decoration: InputDecoration(
                                    labelText: 'نقش در پرونده',
                                    labelStyle: GoogleFonts.cairo(),
                                    prefixIcon: ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                      ).createShader(bounds),
                                      child: const Icon(Icons.assignment_ind, color: Colors.white),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                  items: roles.map((role) {
                                    return DropdownMenuItem(
                                      value: role,
                                      child: Text(role, style: GoogleFonts.cairo(fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 700),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF11998e).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: DropdownButtonFormField<Case>(
                                  value: selectedCase,
                                  decoration: InputDecoration(
                                    labelText: 'پرونده مورد نظر',
                                    labelStyle: GoogleFonts.cairo(),
                                    prefixIcon: ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                                      ).createShader(bounds),
                                      child: const Icon(Icons.folder, color: Colors.white),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                  ),
                                  items: cases.map((caseItem) {
                                    return DropdownMenuItem(
                                      value: caseItem,
                                      child: Text(
                                        '${caseItem.caseNumber} - ${caseItem.caseTitle}',
                                        style: GoogleFonts.cairo(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCase = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 800),
                            child: _buildTextField(
                              controller: _notesController,
                              label: 'یادداشت (اختیاری)',
                              icon: Icons.note,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFf093fb), Color(0xFFF5576c)],
                              ),
                              maxLines: 3,
                            ),
                          ),
                          const SizedBox(height: 30),
                          
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 900),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF11998e).withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: isLoading ? null : registerPerson,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(
                                  'ثبت اطلاعات',
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Gradient gradient,
    TextInputType? keyboardType,
    int? maxLength,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.cairo(),
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: Icon(icon, color: Colors.white),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            counterText: '',
          ),
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          validator: validator,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalCodeController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
