#define static_assert_ALL static_assert( ((MyType::ALL + 2) & (MyType::ALL + 1)) == 0 && MyType::ALL > MyType::LASTBASE );
