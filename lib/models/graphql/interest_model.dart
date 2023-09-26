class InterestsModelForUpdate {
  String interest;
  String _id;

  InterestsModelForUpdate(this.interest, this._id);

  Map<String, dynamic> toJson() {
    return {
      'interest': interest,
      '_id': _id,
    };
  }
}