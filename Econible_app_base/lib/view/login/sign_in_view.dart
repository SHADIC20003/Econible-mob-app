import 'package:flutter/material.dart';
import 'package:trackizer/view/login/sign_up_view.dart';

import '../../common/color_extension.dart';
import '../../common_widget/primary_button.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/secondary_boutton.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isRemember = false;
  bool _isVisible=false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/img/eco3.png",
                  width: media.width * 0.5, fit: BoxFit.contain),
              const Spacer(),
               SizedBox(
                height: 10,
              ),
               const SizedBox(
                height: 45,
               child: Text("please enter your email and password",style: TextStyle(color:Color.fromARGB(255, 188, 68, 2)),),
              ),
              SizedBox(
                height: 10,
              ),
            TextField(
                
                cursorColor: const Color.fromARGB(255, 188, 68, 2) ,
                style: TextStyle(color: TColor.white, fontSize: 14),
                decoration: InputDecoration(
                 
                  enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 107, 104, 102))
                  ),
                  
                  hintText:"Email Ex:ABC@example.com",
                  hintStyle: const TextStyle(color:Color.fromARGB(255, 188, 68, 2)),
                
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                ),
                
               
              ),
              const SizedBox(

                height: 45,
              // child: Text("please enter the email in the correct form",style: TextStyle(color: _isEmailWritternCorrect ? Color.fromARGB(255, 188, 68, 2) : Colors.transparent,),),
              ),
              
              TextField(
                
                cursorColor: const Color.fromARGB(255, 188, 68, 2) ,
                style: TextStyle(color: TColor.white, fontSize: 14),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    }, 
                    icon: _isVisible? const Icon(Icons.visibility,color: Color.fromARGB(255, 188, 68, 2),) : const Icon(Icons.visibility_off,color: Color.fromARGB(255, 188, 68, 2))
                  ),
                  
                  enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 107, 104, 102))
                  ),
                  hintText:"password Ex:********",
                  hintStyle: const TextStyle(color:Color.fromARGB(255, 188, 68, 2)),
                
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                ),
                
                obscureText: !_isVisible,
              ),

               const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isRemember = !isRemember;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isRemember
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          size: 25,
                          color: Color.fromARGB(255, 188, 68, 2),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Remember me",
                          style: TextStyle(color: TColor.gray50, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password",
                      style: TextStyle(color: TColor.gray50, fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 8,
              ),

              PrimaryButton(
                title: "Sign In",
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SocialLoginView(),
                  //   ),
                  // );
                },
              ),
              const Spacer(),
              Text(
                "if you don't have an account yet?",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.white, fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              SecondaryButton(
                title: "Sign up",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpView(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
