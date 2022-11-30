{self, ...}: {
  nixosConfigurations = {
    moghlai = self.lib.nixosSystem {
      arch = "x86_64";
      hostname = "moghlai";
    };

    tandoori = self.lib.nixosSystem {
      arch = "aarch64";
      hostname = "tandoori";
    };
  };

  darwinConfigurations = {
    korai = self.lib.darwinSystem {
      arch = "aarch64";
      hostname = "korai";
    };
  };
}
