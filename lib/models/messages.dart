class Messages {
  Messages({
    required this.msg,
    required this.toID,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromID,
  });
  late final String msg;
  late final String toID;
  late final String read;
  late final String type;
  late final String sent;
  late final String fromID;

  Messages.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    toID = json['toID'].toString();
    read = json['read'].toString();
    type = json['type'].toString();
    sent = json['sent'].toString();
    fromID = json['fromID'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['toID'] = toID;
    data['read'] = read;
    data['type'] = type;
    data['sent'] = sent;
    data['fromID'] = fromID;
    return data;
  }
}
