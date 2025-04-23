#include <Kokkos_Core.hpp>
#include <fmt/core.h>
#include <cstdlib>
#include <chrono>

using Matrix = Kokkos::View<double**, Kokkos::LayoutRight>;

template <typename AMatrixType, typename BMatrixType, typename CMatrixType>
void matrix_product_V2(double alpha, const AMatrixType& A, const BMatrixType& B, double beta, CMatrixType& C, int block_size) {
  const int m = A.extent(0);
  const int k = A.extent(1);
  const int n = B.extent(1);

  const int num_blocks_i = (m + block_size - 1) / block_size;

  Kokkos::parallel_for(
    "dgemm_blocked",
    Kokkos::RangePolicy<>(0, num_blocks_i),
    KOKKOS_LAMBDA(int ii) {
      for (int jj = 0; jj < (n + block_size - 1) / block_size; ++jj) {
        for (int kk = 0; kk < (k + block_size - 1) / block_size; ++kk) {
          const int i0 = ii * block_size;
          const int j0 = jj * block_size;
          const int k0 = kk * block_size;

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
  if (argc < 5) {
    fmt::print("Usage: {} <M> <N> <K> <BLOCK_SIZE>\n", argv[0]);
    return -1;
  }

  int m = std::atoi(argv[1]);
  int n = std::atoi(argv[2]);
  int k = std::atoi(argv[3]);
  int block_size = std::atoi(argv[4]);

  srand48(42);

  Kokkos::initialize(argc, argv);
  {
    Matrix A("A", m, k);
    Matrix B("B", k, n);
    Matrix C("C", m, n);

    double alpha = drand48();
    double beta = drand48();

    Kokkos::parallel_for("init_A", m, KOKKOS_LAMBDA(int i) {
      for (int j = 0; j < k; ++j) A(i, j) = drand48();
    });

    Kokkos::parallel_for("init_B", k, KOKKOS_LAMBDA(int i) {
      for (int j = 0; j < n; ++j) B(i, j) = drand48();
    });

    Kokkos::parallel_for("init_C", m, KOKKOS_LAMBDA(int i) {
      for (int j = 0; j < n; ++j) C(i, j) = drand48();
    });

    Kokkos::fence();

    auto start = std::chrono::high_resolution_clock::now();
    matrix_product_V2(alpha, A, B, beta, C, block_size);
    Kokkos::fence();
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> elapsed = end - start;
    fmt::print("{:.6f}\n", elapsed.count());
  }
  Kokkos::finalize();
  return 0;
}
