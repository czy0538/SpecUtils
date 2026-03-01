#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>

#include "SpecUtils/SpecFile.h"

int main(int argc, char **argv)
{
  if (argc < 2) {
    std::cerr << "Usage: SpecUtilsQtApp <input-spectrum-file>" << std::endl;
    return EXIT_FAILURE;
  }

  SpecUtils::SpecFile specfile;
  if (!specfile.load_file(argv[1], SpecUtils::ParserType::Auto)) {
    std::cerr << "Failed to open spectrum file: " << argv[1] << std::endl;
    return EXIT_FAILURE;
  }

  std::cout << "Opened: " << argv[1] << std::endl;
  std::cout << "Samples: " << specfile.sample_numbers().size() << std::endl;
  std::cout << "Detectors: " << specfile.detector_names().size() << std::endl;

  for (int sample : specfile.sample_numbers()) {
    for (const std::string &detector : specfile.detector_names()) {
      std::shared_ptr<const SpecUtils::Measurement> meas = specfile.measurement(sample, detector);
      if (!meas) {
        continue;
      }
      std::cout << "Sample=" << sample << ", Detector=" << detector
                << ", GammaChannels=" << meas->num_gamma_channels()
                << ", LiveTime=" << meas->live_time() << "s"
                << ", RealTime=" << meas->real_time() << "s"
                << std::endl;
      break;
    }
    break;
  }

  return EXIT_SUCCESS;
}
