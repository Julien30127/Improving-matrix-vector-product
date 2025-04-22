#include <iostream>
#include <cassert>
#include <cstdlib>

#include <Kokkos_Core.hpp>
#include <fmt/core.h>

using Matrix = Kokkos::View<double**, Kokkos::LayoutRight>;

template <class MatrixType>
auto matrix_init(MatrixType& M) -> void {
  static_assert(2 == MatrixType::rank(), "View must be of rank 2");

  Kokkos::parallel_for(
    "init",
    M.extent(0),
    KOKKOS_LAMBDA(int i) {
      for (int j = 0; j < int(M.extent(1)); ++j) {
        M(i, j) = drand48();
      }
    }
  );
}

template <class AMatrixType, class BMatrixType, class CMatrixType>
auto matrix_product(double alpha, AMatrixType const& A, BMatrixType const& B, double beta, CMatrixType& C) -> void {
  static_assert(
    AMatrixType::rank() == 2 && BMatrixType::rank() == 2 && CMatrixType::rank() == 2, "Views must be of rank 2"
  );
  assert(A.extent(0) == C.extent(0));
  assert(B.extent(1) == C.extent(1));
  assert(A.extent(1) == B.extent(0));

  Kokkos::parallel_for(
    "dgemm_kernel",
    A.extent(0),
    KOKKOS_LAMBDA(int i) {
      for (int j = 0; j < int(B.extent(1)); ++j) {
        double acc = 0.0;
        for (int k = 0; k < int(A.extent(1)); ++k) {
          acc += alpha * A(i, k) * B(k, j);
        }
        C(i, j) *= beta + acc;
      }
    }
  );
}

template <typename AMatrixType, typename BMatrixType, typename CMatrixType>
void matrix_product_V2(double alpha, const AMatrixType& A, const BMatrixType& B, double beta, CMatrixType& C, int block_size) {
  const int m = A.extent(0);
  const int k = A.extent(1);
  const int n = B.extent(1);

  Kokkos::parallel_for(
    "dgemm_blocked",
    Kokkos::RangePolicy<>(0, m / block_size),
    KOKKOS_LAMBDA(int bi) {
      for (int bj = 0; bj < n / block_size; ++bj) {
        for (int bk = 0; bk < k / block_size; ++bk) {

          const int i0 = bi * block_size;
          const int j0 = bj * block_size;
          const int k0 = bk * block_size;

          for (int i = i0; i < i0 + block_size && i < m; ++i) {
            for (int j = j0; j < j0 + block_size && j < n; ++j) {
              double acc = 0.0;
              for (int l = k0; l < k0 + block_size && l < k; ++l) {
                acc += alpha * A(i, l) * B(l, j);
              }
              C(i, j) = beta * C(i, j) + acc;
            }
          }

        }
      }
    }
  );
}

auto main(int argc, char* argv[]) -> int {
  if (argc < 4) {
    fmt::print("Usage: {} <M> <N> <K>\n", argv[0]);
    return -1;
  }
  int m = std::atoi(argv[1]);
  int n = std::atoi(argv[2]);
  int k = std::atoi(argv[3]);

  // Known seed for deterministic RNG
  srand48(42);

  Kokkos::initialize(argc, argv);
  {
    auto A = Matrix("A", m, k);
    auto B = Matrix("B", k, n);
    auto C = Matrix("C", m, n);

    double alpha = drand48();
    matrix_init(A);
    matrix_init(B);
    double beta = drand48();
    matrix_init(C);

    // Utilisation de Kokkos::Timer pour mesurer la performance
    Kokkos::Timer timer;

    // Version naïve
    Kokkos::fence();
    matrix_product(alpha, A, B, beta, C);
    Kokkos::fence();

    // Mesurer le temps pour la version naïve
    double naive_time = timer.seconds();
    std::cout << "Temps de multiplication naïve : " << naive_time << " secondes." << std::endl;

    // Calculer les FLOP/s pour la version naïve
    double gflops = (2.0 * m * n * k) / (naive_time * 1e9);
    std::cout << "Naive GFLOP/s: " << gflops << std::endl;


    // Version optimisée avec cache blocking
    Kokkos::Timer timer_blocked;
    int block_size = 64; // Taille du bloc, ajuste selon les tests
    matrix_product_V2(alpha, A, B, beta, C, block_size);
    Kokkos::fence();

    double blocked_time = timer_blocked.seconds();
    std::cout << "Temps de multiplication avec cache blocking : " << blocked_time << " secondes." << std::endl;
  }
  Kokkos::finalize();
  return 0;
}
