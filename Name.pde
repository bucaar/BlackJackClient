class Name {
  private String[] Beginning = { 
    "Kr", "Ca", "Ra", "Mrok", "Cru", 
             "Ray", "Bre", "Zed", "Drak", "Mor", "Jag", "Mer", "Jar", "Mjol", 
             "Zork", "Mad", "Cry", "Zur", "Creo", "Azak", "Azur", "Rei", "Cro", 
             "Mar", "Luk"
  };

     private String[] Middle = { 
    "air", "ir", "mi", "sor", "mee", "clo", 
             "red", "cra", "ark", "arc", "miri", "lori", "cres", "mur", "zer", 
             "marac", "zoir", "slamar", "salmar", "urak"
  };

     private String[] End = { 
    "d", "ed", "ark", "arc", "es", "er", "der", 
             "tron", "med", "ure", "zur", "cred", "mur"
  };
     
       
       public String generateName() {
          return Beginning[(int)random(Beginning.length)] + 
                  Middle[(int)random(Middle.length)]+
                  End[(int)random(End.length)];

       
  }
}
