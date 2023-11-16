import 'package:flutter/material.dart';



class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback whenTaped;
  final bool isLoading ;
  const RoundButton({super.key,
    required this.title,
    required this.whenTaped,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: whenTaped,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isLoading ? Colors.white : Colors.deepPurple
          ),
          child: isLoading
              ? const CircularProgressIndicator(
            // valueColor: AlwaysStoppedAnimation<Color>(Colors.green) ,
            backgroundColor: Colors.black38,
            color: Colors.white,
            strokeWidth: 3,
          )
              : Center(
              child: Text(
                  title,
                style: const TextStyle(
                  color: Colors.white
                ),
              )),

        ),
      ),
    );
  }
}
