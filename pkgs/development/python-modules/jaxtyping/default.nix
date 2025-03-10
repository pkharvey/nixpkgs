{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, pythonRelaxDepsHook
, numpy
, typeguard
, typing-extensions
, cloudpickle
, equinox
, ipython
, jax
, jaxlib
, pytestCheckHook
, tensorflow
, torch
}:

let
  self = buildPythonPackage rec {
    pname = "jaxtyping";
    version = "0.2.27";
    pyproject = true;

    disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "google";
      repo = "jaxtyping";
      rev = "refs/tags/v${version}";
      hash = "sha256-FDXNPu8HZUpT5ij6evc/LKVXAvcDDE9PmOXS7WmADpQ=";
    };

    nativeBuildInputs = [
      hatchling
      pythonRelaxDepsHook
    ];

    propagatedBuildInputs = [
      numpy
      typeguard
      typing-extensions
    ];

    pythonRelaxDeps = [
      "typeguard"
    ];

    nativeCheckInputs = [
      cloudpickle
      equinox
      ipython
      jax
      jaxlib
      pytestCheckHook
      tensorflow
      torch
    ];

    doCheck = false;

    # Enable tests via passthru to avoid cyclic dependency with equinox.
    passthru.tests = {
      check = self.overridePythonAttrs {
        # We disable tests because they complain about the version of typeguard being too new.
        doCheck = false;
        catchConflicts = false;
      };
    };

    pythonImportsCheck = [ "jaxtyping" ];

    meta = with lib; {
      description = "Type annotations and runtime checking for JAX arrays and PyTrees";
      homepage = "https://github.com/google/jaxtyping";
      license = licenses.mit;
      maintainers = with maintainers; [ GaetanLepage ];
    };
  };
 in self
