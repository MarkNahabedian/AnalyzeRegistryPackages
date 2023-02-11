# Script for making "standard" plots.

using AnalyzeRegistryPackages

svg_collected(:src, :readme)
svg_collected(:src, :docs, :readme)
svg_collected(:src, :docs)
svg_collected(:src, :tests)

threshold_satisfaction_plot("satisfies-test_min_fraction",
                            @metric(tests / (tests + src)))

threshold_satisfaction_plot("satisfies-doc_min_fraction",
                            @metric( docs / (docs + src)))

threshold_satisfaction_plot("satisfies-readme_min_fraction",
                            @metric(readme / (readme + src)))

