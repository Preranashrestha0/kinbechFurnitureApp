import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinbech_furnitureapp/Validation/Validator.dart';
import 'package:kinbech_furnitureapp/components/TextFormField.dart';
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final emailcontroller = TextEditingController();




  @override
  void dispose(){
    emailcontroller.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailcontroller.text.trim());
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text('Password reset link sent! check your email'),
          );
        },
      );
      // Clear the email input field after sending the reset link
      emailcontroller.clear();
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white24,
          elevation: 0,
          title: Text(
            'Forgot Password',
            style: TextStyle(
              color: Color(0xff864942),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0), // Adjust the height of the line
            child: Divider(
            color: Colors.grey,
            thickness: 2.0, // Adjust the thickness of the line
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text("Reset account Password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10,),
          Image.asset('assets/images/forgot.png', height: 250),
          SizedBox(height: 10),

          Container(
            width: size.width/1.1,
            child: MyTextFormField(
              controller: emailcontroller,
              hintText: 'Email',
              validator: Validator.validateEmail,

            ),
          ),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: passwordReset,
                child: Container(
                  height: size.height / 15,
                  width: size.width / 2,
                  decoration: BoxDecoration(
                      color: Color(0xff864942),
                      borderRadius: BorderRadius.circular(6)),
                  child: Center(
                      child: Text(
                        "Send Reset Link",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inika',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
