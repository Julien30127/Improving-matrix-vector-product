#include <cassert>
#include <cstdlib>
#include <Kokkos_Core.hpp>
#include <Kokkos_Timer.hpp>
#include <fmt/core.h>


using MatrixLeft = Kokkos::View<double**, Kokkos::LayoutLeft>;

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
auto matrix_product_left(double alpha, AMatrixType const& A, BMatrixType const& B, double beta, CMatrixType& C) -> void {
  static_assert(
    AMatrixType::rank() == 2 && BMatrixType::rank() == 2 && CMatrixType::rank() == 2, "Views must be of rank 2"
  );
  assert(A.extent(0) == C.extent(0));
  assert(B.extent(1) == C.extent(1));
  assert(A.extent(1) == B.extent(0));

  Kokkos::parallel_for(
    "dgemm_kernel_left",
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


auto main(int argc, char* argv[]) -> int {
  if (argc < 4) {
    fmt::print("Usage: {} <M> <N> <K>\n", argv[0]);
    return -1;
  }
  int m = std::atoi(argv[1]);
  int n = std::atoi(argv[2]);
  int k = std::atoi(argv[3]);

  srand48(42);

  Kokkos::initialize(argc, argv);
  {
    // Créer les matrices avec le layout Left
    auto A_left = MatrixLeft("A_left", m, k);
    auto B_left = MatrixLeft("B_left", k, n);
    auto C_left = MatrixLeft("C_left", m, n);

    // Initialisation des matrices
    double alpha = drand48();
    matrix_init(A_left);
    matrix_init(B_left);

    double beta = drand48();
    matrix_init(C_left);

    Kokkos::fence();

    // Calcul du produit matriciel
    Kokkos::Timer timer;
    matrix_product_left(alpha, A_left, B_left, beta, C_left);

    Kokkos::fence();
    double elapsed = timer.seconds();

    fmt::print("{:.6f}\n", elapsed);
  }
  Kokkos::finalize();
  return 0;
}
