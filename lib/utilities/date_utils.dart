import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///date picker
Future<DateTime?> datePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime.now(),
    lastDate: lastDate ?? DateTime(2101),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: const Color(0xFF584778),
          colorScheme: const ColorScheme.light(primary: Color(0xFF584778)),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        child: child!,
      );
    },
  );
  return picked;
}

///date formatter
String getFormattedDate(DateTime date, String format) {
  DateFormat dateFormat = DateFormat(format);
  return dateFormat.format(date);
}

String timeStampToDateForUserListing(int timestamp) {
  var now = DateTime.now();
  var date = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    if (diff.inSeconds <= 60 && diff.inMinutes == 0) {
      time = "Now";
    } else if (diff.inMinutes == 1 && diff.inHours == 0) {
      time = '${diff.inMinutes} min ago';
    } else if (diff.inMinutes > 1 && diff.inHours == 0) {
      time = '${diff.inMinutes} mins ago';
    } else if (diff.inHours == 1) {
      time = '${diff.inHours} hour ago';
    } else if (diff.inHours > 1) {
      time = '${diff.inHours} hours ago';
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} day ago';
    } else {
      time = '${diff.inDays} days ago';
    }
  } else {
    if (diff.inDays == 7) {
      time = '${(diff.inDays / 7).floor()} week ago';
    } else {
      var tempDays = diff.inDays / 7;
      if (tempDays <= 4) {
        time = '${(diff.inDays / 7).floor()} weeks ago';
      } else if (tempDays == 4) {
        time = '${(tempDays / 4).floor()} month ago';
      } else if (tempDays > 4 && tempDays <= 53) {
        time = '${(tempDays / 4).floor()} months ago';
      } else if (tempDays > 53 && tempDays <= 105) {
        time = "1 Year ago";
      } else {
        time = "Few years ago";
      }
    }
  }

  return time;
}

int getCurrentTimeStamp() {
  var timeStamp = DateTime.now().microsecondsSinceEpoch;
  return timeStamp;
}

String timeStampToDateFormat(int timestamp, String dateTimeFormat) {
  var now = DateTime.now();
  var format = DateFormat(dateTimeFormat);
  var date = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} DAY AGO';
    } else {
      time = '${diff.inDays} DAYS AGO';
    }
  } else {
    if (diff.inDays == 7) {
      time = '${(diff.inDays / 7).floor()} WEEK AGO';
    } else {
      time = '${(diff.inDays / 7).floor()} WEEKS AGO';
    }
  }
  return time;
}

String timeStampToDate(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('hh:mm a');
  var date = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} DAY AGO';
    } else {
      time = '${diff.inDays} DAYS AGO';
    }
  } else {
    if (diff.inDays == 7) {
      time = '${(diff.inDays / 7).floor()} WEEK AGO';
    } else {
      time = '${(diff.inDays / 7).floor()} WEEKS AGO';
    }
  }

  return time;
}

String dateToAgoFormat(DateTime date) {
  var now = DateTime.now();
  var format = DateFormat('hh:mm a');
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '${diff.inDays} day ago';
    } else {
      time = '${diff.inDays} days ago';
    }
  } else {
    if (diff.inDays == 7) {
      time = '${(diff.inDays / 7).floor()} week ago';
    } else {
      time = '${(diff.inDays / 7).floor()} weeks ago';
    }
  }

  return time;
}

bool isDelayCompletedForResendOtp(int lastOtpSendTime) {
  int currentTimeMilles = DateTime.now().millisecondsSinceEpoch;
  int differenceSeconds = (currentTimeMilles - lastOtpSendTime) ~/ 1000;
  return differenceSeconds > 60;
}

int getDelayTimeForResendOtp(int lastOtpSendTime) {
  int currentTimeMilles = DateTime.now().millisecondsSinceEpoch;
  int differenceSeconds = (currentTimeMilles - lastOtpSendTime) ~/ 1000;
  return 60 - differenceSeconds;
}

String convertDate(String date) {
  // Parse the input string as a DateTime object
  final parsedDate = DateFormat('dd/MM/yyyy').parse(date);

  // Format the DateTime object as a string in the desired format
  final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(parsedDate);

  // Return the formatted date string
  return formattedDate;
}

bool isDateOfBirthValid(String input) {
  try {
    DateFormat format = DateFormat("dd/MM/yyyy");
    format.parseStrict(input);
  } on FormatException {
    return false;
  }
  return true;
}

String convertDateFormat(
  String date,
  String inputDateFormat,
  String outputDateFormat,
) {
  try {
    // Remove milliseconds from the input date string
    final dateWithoutMilliseconds = date.split('.')[0];

    // Parse the modified input string as a DateTime object
    final parsedDate =
        DateFormat(inputDateFormat).parse(dateWithoutMilliseconds);

    // Format the DateTime object as a string in the desired format
    final formattedDate = DateFormat(outputDateFormat).format(parsedDate);

    // Return the formatted date string
    return formattedDate;
  } catch (e) {
    print(e.toString());
  }
  return date;
}

int calculateAge(
  String dateOfBirth, {
  String dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'",
}) {
  if (dateOfBirth.isEmpty) {
    return 0;
  }
  DateTime now = DateTime.now();
  DateTime birthDate = DateFormat(dateFormat).parseUtc(dateOfBirth);

  int age = now.year - birthDate.year;

  // Check if the birth date hasn't occurred yet in the current year
  bool hasBirthdayOccurred = now.month > birthDate.month ||
      (now.month == birthDate.month && now.day >= birthDate.day);
  if (!hasBirthdayOccurred) {
    age--;
  }

  return age;
}

DateTime convertToDateTime(String date) {
  List<String> dateParts = date.split('/');
  String reformattedDate = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";

  return DateTime.parse(reformattedDate);
}

String getExpireTime(String date) {
  DateTime expiryDate = DateTime.parse(date).toUtc();
  final now = DateTime.now().toLocal();
  String expiryText = '';
  Duration timeDifference = now.difference(expiryDate);
  if (timeDifference.inMilliseconds <= 1000) {
    expiryText += '1 seconds';
  } else if (timeDifference.inSeconds < 60) {
    expiryText += '${timeDifference.inSeconds} seconds';
  } else if (timeDifference.inMinutes < 60) {
    expiryText += '${timeDifference.inMinutes} minutes';
  } else if (timeDifference.inHours < 24) {
    expiryText += '${timeDifference.inHours} hours';
    expiryText +=
        ' ${timeDifference.inMinutes - (60 * timeDifference.inHours)} minutes';
  } else {
    expiryText += '${timeDifference.inDays} days';
  }

  return expiryText + "\tago";
}
