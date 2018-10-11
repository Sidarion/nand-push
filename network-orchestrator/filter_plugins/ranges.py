def ranges(input):
    input.sort()

    output = {}
    outputKey = -1
    for number in input:
        if outputKey not in output:
            outputKey += 1
            output[outputKey] = {0: number, 1: number}
            continue
    
        if output[outputKey][1] + 1 == number:
            output[outputKey][1] = number
            continue
    
        outputKey += 1
        output[outputKey] = {0: number, 1: number}
    
    ranges = []
    for key in output:
        numbers = output[key]
        if numbers[0] == numbers[1]:
            ranges.append(str(numbers[0]))
            continue
        ranges.append(str(numbers[0])+'-'+str(numbers[1]))
 
    return ' '.join(ranges)

class FilterModule(object):
    '''
    custom jinja2 filters for working with collections
    '''
    def filters(self):
        return {
            'ranges': ranges
        }
