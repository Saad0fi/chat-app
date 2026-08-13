import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sao/feature/auth/bloc/auth_bloc.dart';
import 'package:sao/feature/chat/screens/home_screen/home_screen.dart';
import 'package:sao/feature/auth/screens/sign_up_screen.dart';

class LoginInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AuthBloc>();

          return Scaffold(
            body: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is SucsessSignin) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Colors.green[600],
                          ),
                          SizedBox(height: 20),

                          Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 40),

                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final bloc = context.read<AuthBloc>();
                              return TextFormField(
                                controller: bloc.emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'البريد الإلكتروني',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال البريد الإلكتروني';
                                  }
                                  if (!value.contains('@')) {
                                    return 'البريد الإلكتروني غير صحيح';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          SizedBox(height: 16),

                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final bloc = context.read<AuthBloc>();
                              return TextFormField(
                                controller: bloc.passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال كلمة المرور';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          SizedBox(height: 32),

                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      state is AuthInitial || state is AuthError
                                      ? () {
                                          bloc.add(trySignIn());
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: state is AuthLoading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'تسجيل الدخول',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('ليس لديك حساب؟ '),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'إنشاء حساب',
                                  style: TextStyle(color: Colors.green[800]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
