class Profile {
  final String email;
  final String smtpServer;
  final String imapServer;
  final String password;
  final bool useSSL;

  Profile({
    required this.email,
    required this.smtpServer,
    required this.imapServer,
    required this.password,
    this.useSSL = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'smtpServer': smtpServer,
      'imapServer': imapServer,
      'password': password,
      'useSSL': useSSL,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json['email'],
      smtpServer: json['smtpServer'],
      imapServer: json['imapServer'],
      password: json['password'],
      useSSL: json['useSSL'],
    );
  }
}