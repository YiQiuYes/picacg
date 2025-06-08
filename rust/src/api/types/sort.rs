pub struct Sort(&'static str);

impl Sort {
    pub const SORT_DEFAULT: Sort = Sort("ua");
    pub const SORT_TIME_NEWEST: Sort = Sort("dd");
    pub const SORT_TIME_OLDEST: Sort = Sort("da");
    pub const SORT_LIKE_MOST: Sort = Sort("ld");
    pub const SORT_VIVE_MOST: Sort = Sort("vd");

    pub fn as_str(&self) -> &'static str {
        self.0
    }
}
