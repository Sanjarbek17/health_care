import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

class User extends StatelessWidget {
  final String message;
  const User({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                message,
                softWrap: true,
                maxLines: 10,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Assistant extends StatelessWidget {
  final String message;
  const Assistant({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: message != ''
                      ? Text(
                          message,
                          softWrap: true,
                          maxLines: 10,
                          style: const TextStyle(color: Colors.white),
                        )
                      : Row(
                          children: [
                            JumpingDots(
                              color: Colors.white,
                              radius: 7,
                              verticalOffset: -7,
                              numberOfDots: 3,
                              animationDuration: const Duration(milliseconds: 200),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
