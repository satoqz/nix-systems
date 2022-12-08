{self, ...}: {
  nixosConfigurations = {
    moghlai = self.lib.mkSystem {
      system = "x86_64-linux";
      hostname = "moghlai";
    };

    tandoori = self.lib.mkSystem {
      system = "aarch64-linux";
      hostname = "tandoori";
    };
  };

  darwinConfigurations = {
    korai = self.lib.mkSystem {
      system = "aarch64-darwin";
      hostname = "korai";
    };
  };
}
