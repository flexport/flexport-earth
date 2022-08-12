type DataPage<DataType> = {
    prev:  string,
    next:  string,
    total: number,
    data:  DataType[]
};

export default DataPage;
